module AttendanceAwards

  class << self
 
    def hoodies regs, params
      awarded_students regs, hoodie_count(params)
    end

    def t_shirts regs, params
      awarded_students regs, t_shirt_count(params)
    end

    def awarded_students regs, group
      regs.where(id: Attendance.attendence_ids_with_count_greater_than(group))
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
