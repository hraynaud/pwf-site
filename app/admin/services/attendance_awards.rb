class AttendanceAwards

    def initialize hoodie, t_shirt
      @hoodie = hoodie
      @t_shirt = t_shirt
      @regs = StudentRegistration.current.confirmed
    end

    def hoodies
      base_query(hoodie_count,Season.current.num_sessions)
    end

    def hoodie_count 
      get_count_from_pct hoodie_pct
    end

    def hoodie_pct 
      (@hoodie) || Season.current.min_for_hoodie
    end

    def t_shirts
      base_query(t_shirt_count,  hoodie_count)
    end

    def t_shirt_count 
      get_count_from_pct t_shirt_pct
    end

    def t_shirt_pct 
      (@t_shirt) || Season.current.min_for_t_shirt
    end

    def no_award 
      base_query( 0,t_shirt_count)
    end

    def hoodies_breakdown
      group_breakdown hoodies_total
    end

    def t_shirt_breakdown
      group_breakdown t_shirt_total
    end

    private

    def get_count_from_pct pct
      (num_sessions*to_hundreth(pct)).round
    end

    def num_sessions
      @sessions ||= Season.current.num_sessions
    end

    def base_query  low, high
      @regs.where(id: Attendance.attendance_ids_with_count_within_range(low, high))
    end

    def to_hundreth val
      val*0.01
    end

    def group_breakdown group
      breakdown = {}
      group.each do |size, count|
        breakdown[sizes_table(size)] = count
      end 
      breakdown
    end

    def hoodies_total
      awarded_students hoodie_count
    end

    def t_shirt_total
      awarded_students t_shirt_count
    end

    def sizes_table size
      StudentRegistration.sizes_table[size]
    end

    def awarded_students group
      StudentRegistration.select("size_cd, count(size_cd)")
        .from(
          @regs.where(
            id: Attendance.current.attendance_ids_with_count_greater_than(group)
          )
      ).group("size_cd").size
    end

end
