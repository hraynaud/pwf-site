module AttendanceAwards

  class << self

    def hoodies regs, params
      base_query(regs, hoodie_count(params), Season.current.num_sessions)
    end

    def t_shirts regs, params
      base_query(regs, t_shirt_count(params), hoodie_count(params))
    end

    def no_award regs, params
      base_query(regs, 0,t_shirt_count(params))
    end

    def base_query regs, low, high
      regs.where(id: Attendance.attendance_ids_with_count_within_range(low, high))
    end

    def hoodies_breakdown regs, params
       breakdown = {}
      hoodies_total(regs, params).each do |size, count|
        breakdown[StudentRegistration.sizes_table[size]] = count
      end 
      breakdown
    end

    def tshirt_breakdown regs, params
       breakdown = {}
      t_shirt_total(regs, params).each do |size, count|
        breakdown[StudentRegistration.sizes_table[size]] = count
      end 
      breakdown
    end

    def hoodies_total regs, params
      awarded_students regs, hoodie_count(params)
    end

    def t_shirt_total regs, params
      awarded_students regs, t_shirt_count(params)
    end

    def awarded_students regs, group
      StudentRegistration.select("size_cd, count(size_cd)")
        .from(
          regs.where(
            id: Attendance.current.attendance_ids_with_count_greater_than(group)
          )
      ).group("size_cd").size
    end

    def hoodie_count params
      get_count_from_pct(hoodie_pct(params))
    end

    def t_shirt_count params
      get_count_from_pct(t_shirt_pct(params))
    end

    def hoodie_pct params
      params.dig("q", "h_eq") ?  params.dig("q", "h_eq").to_f : Season.current.min_for_hoodie
    end

    def t_shirt_pct params
      params.dig("q", "t_eq") ? params.dig("q", "t_eq").to_f : Season.current.min_for_t_shirt
    end

    def get_count_from_pct pct
      (num_sessions*to_hundreth(pct)).round
    end

    def num_sessions
      @sessions ||= Season.current.num_sessions
    end

    def to_hundreth val
      val*0.01
    end
  end

end
