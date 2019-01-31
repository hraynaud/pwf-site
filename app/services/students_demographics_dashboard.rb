module StudentsDemographicsDashboard
  class << self
    def stat_calculator
      @stat ||= StatCalculator.new(Demographic.for_current_confirmed_students)
    end

    def pct_of_students_per_incomge_range
      stat_calculator.percentage_breakdown :income_range_cd, Demographic.income_ranges.keys 
    end

    def pct_of_students_per_housing_status
      stat_calculator.percentage_breakdown :home_ownership_cd, Demographic.home_ownerships.keys
    end

    def pct_of_students_per_max_education_level
      stat_calculator.percentage_breakdown :education_level_cd,  Demographic.education_levels.keys
    end

    def count_of_students_per_incomge_range
      stat_calculator.count_breakdown :income_range_cd, Demographic.income_ranges.keys 
    end

    def count_of_students_per_housing_status
      stat_calculator.count_breakdown :home_ownership_cd, Demographic.home_ownerships.keys
    end

    def count_of_students_per_max_education_level
      stat_calculator.count_breakdown :education_level_cd,  Demographic.education_levels.keys
    end

    def pct_of_students_per_gender
      stat_calculator.percentage_breakdown :gender, ['M', 'F'] 
    end

    def count_of_students_per_gender
      stat_calculator.count_breakdown :gender, ['M', 'F'] 
    end

  end
end
