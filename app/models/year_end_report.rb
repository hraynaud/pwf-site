class YearEndReport < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :aep_registration
  belongs_to :tutor
  has_one :student_registration, :through=> :aep_registration
  has_one :student, :through=> :student_registration
  attr_accessible :academic_skills, :achievements, :aep_registration_id, :attendance, 
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :tutor_id, :confirmed

  validates :academic_skills, :achievements, :aep_registration_id, :attendance,
    :challenges_concerns, :comments, :participation, :preparation, :recommendations, :tutor_id, :presence => true
  delegate :name, :to =>:student, :prefix=> true 
  delegate :name, :to =>:tutor, :prefix=> true 
  delegate :term, :to =>:aep_registration

end
