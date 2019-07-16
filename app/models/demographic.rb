class Demographic < ApplicationRecord
  belongs_to :parent
  belongs_to :season

  validates :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season, :presence => true

  DEGREE = ["High School", "Associates",  "Bachelors",  "Masters",  "Doctorate"]
  as_enum :education_level, DEGREE

  INCOME = ["$0 - $24 999",  "$25,000 - $49,999",  "$50,000 - $74,9999",  "$75,000 - $99,999",  "$100,000 - $124,999",  "$125,000 - $149,999", "150,000 - $174,999", "$175,000 - $200,000", "200,000+" ]
  as_enum :income_range, INCOME

  as_enum :home_ownership, [:Own, :Rent, :Other]

  before_validation :set_season

  scope :current, ->(){where(season_id: Season.current_season_id)}
  scope :by_season,->(id){where(season_id: id)}

  class << self

    def for_season_all_students id = Season.current_season_id
      for_confirmed_student.merge(StudentRegistration.by_season(id))
    end

    def for_season_students_in_aep id = Season.current_season_id
      for_confirmed_student.merge(StudentRegistration.by_season(id).in_aep)
    end

    def with_students
      joins(parent: :student_registrations)
    end

    def for_confirmed_student
      with_students.where("demographics.season_id = student_registrations.season_id and student_registrations.status_cd in (1,2)")
    end

  end

  private

  def set_season
    if self.season.nil?
      self.season = Season.current
    end
  end
end
