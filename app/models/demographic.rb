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

    def income_breakdown_for_current_confirmed_students
      calc_stat(for_current_confirmed_students, income_ranges.keys, :income_range_cd) 
    end

    def home_ownership_breakown_for_current_confirmed_students
      calc_stat(for_current_confirmed_students, home_ownerships.keys, :home_ownership_cd) 
    end

    def education_level_breakown_for_current_confirmed_students
      calc_stat(for_current_confirmed_students, education_levels.keys, :education_level_cd) 
    end

    def calc_stat dataset, type, column

      Hash[
        map_groups_to_values(
          get_percents(
            get_counts(dataset, column)
          ),
          type)
      ]
    end

    def get_counts dataset, column
      group_counts_of(dataset, column).values 
    end

    def get_percents values 
      values.map{|v| (v*100.to_f/values.sum).round(3)}
    end

    def map_groups_to_values data, type
      type.zip(data)
    end

    def group_counts_of dataset, column
      dataset.group(column).count
    end

  end

  private

  def set_season
    if self.season.nil?
      self.season = Season.current
    end
  end
end
