class YearEndReport < ApplicationRecord
  include ReportBehavior

  validates :academic_skills, :achievements, :attendance,
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :presence => true


  def name
    "#{student_name} > #{term}"
  end
end
