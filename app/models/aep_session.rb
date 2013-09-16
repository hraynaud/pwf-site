class AepSession < ActiveRecord::Base
  attr_accessible :notes, :session_date, :season_id

  has_many :aep_attendances, :include => ({:aep_registration => {:student_registration => :student}}), :dependent => :destroy, :order => "students.last_name asc"
  belongs_to :season 
  attr_accessible :session_date, :notes, :aep_attendances_attributes, :season_id
  accepts_nested_attributes_for :aep_attendances

  delegate :term, to: :season
  before_create :set_enrollment_count

 private

 def set_enrollment_count
   self.enrollment_count = AepRegistration.current.paid
 end


end
