class Demographic < ApplicationRecord
  belongs_to :parent
  belongs_to :season

  validates :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season, :presence => true

  DEGREE = ["High School", "Associates",  "Bachelors",  "Masters",  "Doctorate"]
  as_enum :education_level, DEGREE

  INCOME = ["$0 - $24 999",  "$25,000 - $49,999",  "$50,000 - $74,9999",  "$75,000 - $99,999",  "$100,000 - $124,999",  "125, 000+" ]
  as_enum :income_range, INCOME

  as_enum :home_ownership, [:Own, :Rent, :Other]

  before_validation :set_season

  scope :current, ->(){where(season_id: Season.current_season_id)}

  class << self

    def for_current_confirmed_students
      current.joins(parent: :student_registrations)
        .merge(StudentRegistration.current_confirmed)
    end

    #def stat_calculator
      #@stat ||= StatCalculator.new(for_current_confirmed_students)
    #end

    #def income_breakdown_for_current_confirmed_students
      #stat_calculator.calculate(income_ranges.keys, :income_range_cd)
    #end

    #def home_ownership_breakown_for_current_confirmed_students
      #stat_calculator.calculate(home_ownerships.keys, :home_ownership_cd)
    #end

    #def education_level_breakown_for_current_confirmed_students
      #stat_calculator.calculate(education_levels.keys, :education_level_cd)
    #end

  end

  private

  def set_season
    if self.season.nil?
      self.season = Season.current
    end
  end
end
