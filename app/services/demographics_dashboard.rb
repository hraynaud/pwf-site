module DemographicsDashboard
  class << self
    def stat_calculator
      @stat ||= StatCalculator.new(Demographic.for_current_confirmed_students)
    end

    def income_breakdown_graph
      graph_data Demographic.income_ranges.keys, :income_range_cd
    end

    def home_ownership_breakown_graph
      graph_data Demographic.home_ownerships.keys, :home_ownership_cd
    end

    def education_level_breakown_graph
      graph_data Demographic.education_levels.keys, :education_level_cd
    end

    def graph_data column, groupings
      stat_calculator.get_percentage_breakdown(groupings, column)
    end

  end
end
