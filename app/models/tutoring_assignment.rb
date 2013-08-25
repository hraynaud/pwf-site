class TutoringAssignment < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student_registration
  has_one :student, :through => :student_registration
  belongs_to :subject
  attr_accessible :notes, :student_registration_id, :subject_id, :tutor_id
end
