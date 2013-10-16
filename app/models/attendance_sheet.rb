class AttendanceSheet < ActiveRecord::Base
  has_many :attendances, :include => ({:student_registration => :student}), :dependent => :destroy, :order => "students.last_name asc"
  belongs_to :season
  attr_accessible :session_date, :attendances_attributes, :season_id
  accepts_nested_attributes_for :attendances

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date
  delegate :term, to: :season
  before_create :set_enrollment_count

  def attendees
   attendances.present 
  end

  def attendees_count
   attendees.count 
  end

  def absentees
   attendances.absent 
  end

  def absentees_count
   absentees.count 
  end

  def current_students
     attendances.map{|a| {id: a.id, name: a.student_name, attended: a.attended}}
  end

 private

 def set_enrollment_count
   self.enrollment_count = StudentRegistration.current.enrolled.count
 end

end
