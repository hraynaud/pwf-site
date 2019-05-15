module AttendanceAwards

  class Test
    def initialize hoodie, t_shirt
      @hoodie = hoodie
      @t_shirt = t_shirt
      @regs = StudentRegistration.current.confirmed
    end
    def hoodies
      AttendanceAwards.hoodies(@regs, @hoodie)
    end
    def t_shirts
      AttendanceAwards.t_shirts_plus(@regs, @hoodie, @t_shirt)
    end

    def no_award 
      AttendanceAwards.no_award(@regs, @t_shirt)
    end

    def hoodie_count 
      AttendanceAwards.get_count_from_pct(hoodie_pct)
    end

    def hoodie_pct 
      (@hoodie) || Season.current.min_for_hoodie
    end


    def t_shirt_count 
      AttendanceAwards.get_count_from_pct(t_shirt_pct)
    end

    def t_shirt_pct 
      (@t_shirt) || Season.current.min_for_t_shirt
    end

    def hoodies_breakdown
      AttendanceAwards.hoodies_breakdown(@regs,@hoodie)
    end

    def t_shirt_breakdown
      AttendanceAwards.t_shirt_breakdown(@regs,@t_shirt)
    end
  end

  class << self

    def hoodies regs, params
      base_query(regs, hoodie_count(params), Season.current.num_sessions)
    end

    def t_shirts regs, params
      base_query(regs, t_shirt_count(params), hoodie_count(params))
    end
     def t_shirts_plus regs, h_param, t_param
      base_query(regs, t_shirt_count(t_param), hoodie_count(h_param))
    end

    def no_award regs, params
      base_query(regs, 0,t_shirt_count(params))
    end

    def base_query regs, low, high
      regs.where(id: Attendance.attendance_ids_with_count_within_range(low, high))
    end

    def hoodies_breakdown regs, params
      group_breakdown hoodies_total(regs, params)
    end

    def t_shirt_breakdown regs, params
      group_breakdown t_shirt_total(regs, params)
    end

    def group_breakdown group
      breakdown = {}
      group.each do |size, count|
        breakdown[sizes_table(size)] = count
      end 
      breakdown
    end

    def hoodies_total regs, params
      awarded_students regs, hoodie_count(params)
    end

    def t_shirt_total regs, params
      awarded_students regs, t_shirt_count(params)
    end

    def sizes_table size
      StudentRegistration.sizes_table[size]
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
      #params.dig("q", "h_eq") ?  params.dig("q", "h_eq").to_f : Season.current.min_for_hoodie
      params || Season.current.min_for_hoodie
    end

    def t_shirt_pct params
      #params.dig("q", "t_eq") ? params.dig("q", "t_eq").to_f : Season.current.min_for_t_shirt
      params || Season.current.min_for_t_shirt
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
