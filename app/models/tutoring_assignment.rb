class TutoringAssignment < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student_registration
  belongs_to :aep_registration
  has_one :student, :through => :student_registration
  has_many :monthly_reports
  has_many :session_reports
  has_one :year_end_report
  belongs_to :subject
  attr_accessible :notes, :aep_registration_id, :subject_id, :tutor_id
  validates :tutor, :presence => true
  validates :aep_registration, :presence => true
  delegate :name, :to => :student, :prefix => true
  delegate :name, :to => :tutor, :prefix => true
  before_create :set_student_registration


  private 
   def set_student_registration
     self.student_registration_id = aep_registration.student_registration.id
   end

end
