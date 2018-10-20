class TutoringAssignment < ApplicationRecord
  belongs_to :tutor
  belongs_to :student_registration
  belongs_to :aep_registration
  has_one :student, :through => :student_registration
  has_many :monthly_reports
  has_many :session_reports
  has_one :year_end_report
  belongs_to :subject
  validates :tutor, :presence => true
  validates :aep_registration, :presence => true
  delegate :name, :to => :student, :prefix => true
  delegate :name, :to => :tutor, :prefix => true
  before_create :set_student_registration

 def subject_name
   subject.nil? ? "" : subject.name
 end

  def name
     "#{student_name} > #{tutor_name}"
  end

  def self.current
   joins(aep_registration:[:season]).where("aep_registrations.season_id = #{Season.current_season_id}")
  end

  private 
   def set_student_registration
     self.student_registration_id = aep_registration.student_registration.id
   end

end
