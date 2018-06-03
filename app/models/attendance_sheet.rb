class AttendanceSheet < ActiveRecord::Base
  has_many :attendances, ->{includes :student_registration}, :dependent => :destroy
  belongs_to :season

  accepts_nested_attributes_for :attendances

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date
  delegate :term, to: :season
  before_create :set_enrollment_count
  scope :current, ->{joins(:season).merge(Season.current_active)}

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
     attendances.map do |a|
      {attendanceId: a.id, name: a.student_name, attended: a.attended, studentId: a.student_registration_id, groupId: a.group_id}
    end
  end

 private

 def set_enrollment_count
   self.enrollment_count = StudentRegistration.current.confirmed.count
 end

end
