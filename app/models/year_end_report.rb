class YearEndReport < ActiveRecord::Base
  include ReportBehavior
  attr_accessible :academic_skills, :achievements, :attendance, 
    :challenges_concerns, :comments, :participation, :preparation, :recommendations 

  validates :academic_skills, :achievements, :attendance,
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :presence => true


  def name
    "#{student_name} > #{term}"
  end
end
