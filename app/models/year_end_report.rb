class YearEndReport < ActiveRecord::Base
  include ReportBehavior
  attr_accessible :academic_skills, :achievements, :aep_registration_id, :attendance, 
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :tutor_id, :confirmed

  validates :academic_skills, :achievements, :aep_registration_id, :attendance,
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :tutor_id, :presence => true
end
