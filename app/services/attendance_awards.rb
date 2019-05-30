module AttendanceAwards

  class << self

    def hoodie_count  params
      Calculator.hoodie_count params
    end

    def t_shirt_count  params
      Calculator.t_shirt_count params
    end

    def hoodie_pct params
      Calculator.hoodie_pct params
    end

    def t_shirt_pct params
      Calculator.t_shirt_pct params
    end

    def hoodies regs, params
      Calculator.new(regs, params).hoodies
    end

    def t_shirts regs, params
     Calculator.new(regs, params).t_shirts
    end

    def no_award regs, params
      Calculator.new(regs, params).no_award
    end

    def hoodies_total regs, params
      Calculator.new(regs, params).hoodies_total
    end

    def t_shirt_total regs, params
      Calculator.new(regs, params).t_shirt_total
    end

    def hoodies_breakdown regs, params
      Calculator.new(regs, params).hoodies_breakdown
    end

    def t_shirt_breakdown regs, params
      Calculator.new(regs, params).t_shirt_breakdown
    end

  end

  class Calculator
    attr_reader :regs, :params

    def initialize regs, params
      @regs = regs
      @params = params
      @as_of_date = self.class.as_of_date(params)
      @hoodie_pct = self.class.hoodie_pct(params)
      @t_shirt_pct = self.class.t_shirt_pct(params)
      @hoodie_count = self.class.hoodie_count(params)
      @t_shirt_count = self.class.t_shirt_count(params)
    end

    class << self
      def hoodie_pct params
        extract_params(params, "h_eq", Season.current.min_for_hoodie).to_f
      end

      def t_shirt_pct params
        extract_params(params, "t_eq", Season.current.min_for_t_shirt).to_f
      end

      def hoodie_count params
        get_count_from_pct( num_sessions(params), hoodie_pct(params))
      end

      def t_shirt_count params
        get_count_from_pct(num_sessions(params), t_shirt_pct(params))
      end

      def num_sessions params
        Season.current.num_sessions_as_of(as_of_date(params))
      end

      def as_of_date params
        extract_params params, "asof_eq", Date.today
      end

      def extract_params params, key, defaut_value
        params.dig("q", key) ? params.dig("q", key) : defaut_value
      end

      def get_count_from_pct sessions, pct
        ( sessions * to_hundreth(pct)).round
      end

      def to_hundreth val
        val*0.01
      end
    end

   def as_of_cutoff_date 
     Attendance.as_of(@as_of_date)
   end

   def hoodies 
      regs.where(id: as_of_cutoff_date
       .student_registration_ids_with_count_greater_than_or_eq(@hoodie_count))
   end

    def t_shirts
      regs.where(id: as_of_cutoff_date
        .student_registration_ids_with_count_within_range(@t_shirt_count, @hoodie_count))
    end

    def no_award
      regs.where(id: as_of_cutoff_date
        .student_registration_ids_with_count_less_than(@t_shirt_count))
    end

    def hoodies_total 
      awarded_students @hoodie_count
    end

    def t_shirt_total 
      awarded_students  @t_shirt_count
    end

    def hoodies_breakdown 
      breakdown_for hoodies_total()
    end

    def t_shirt_breakdown 
      breakdown_for t_shirt_total()
    end

    def breakdown_for award_group
      breakdown = {}
      award_group.each do |size, count|
        breakdown[StudentRegistration.sizes_table[size]] = count
      end 
      breakdown
    end

    def awarded_students group
      StudentRegistration.select("size_cd, count(size_cd)")
        .from(
          regs.where(
            id: as_of_cutoff_date
            .current.student_registration_ids_with_count_greater_than_or_eq(group)
          )
      ).group("size_cd").size
    end

  end

end

