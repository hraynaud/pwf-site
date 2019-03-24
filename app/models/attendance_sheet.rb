class AttendanceSheet < ApplicationRecord
  has_many :student_attendances, ->{includes :student_registration}, :dependent => :destroy, class_name: "Attendance"

  has_many :staff_attendances, ->{includes :staff}, :dependent => :destroy
  belongs_to :season

  accepts_nested_attributes_for :student_attendances

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date
  delegate :term, to: :season
  scope :current, ->{joins(:season).merge(Season.current_active)}

  attr_accessor :attendee_type

  def attendances
   @student_attendances ||= attendance_by_type
  end

  def status_for reg_id
    attendance = attendance_for(reg_id)
    if attendance
      status = attendance.attended? ? :present : :absent
      {attendanceId: attendance.id, status: status }
    else
      {attendanceId: nil, status: :missing}
    end 
  end

  def attendance_for reg_id
    attendances.where(student_registration_id: reg_id).first
  end

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

  def generate_attendances
    Attendance.import build_attendances
  end

  def as_json options
    {id: id, date: session_date, students: student_attendances_as_json, staff: staff_attendances_as_json}
  end

  def student_attendances_as_json
    attendances.ordered.as_json({})
  end

  def staff_attendances_as_json
    staff_attendances.ordered.as_json({})
  end

  def formatted_session_date
    session_date.strftime("%B-%d-%Y")
  end

  private
 
  def attendance_by_type
    attendee_type == "staff" ? staff_attendances : student_attendances.with_student
  end

  def build_attendances
    StudentRegistration.current_confirmed.map do |reg|
      attendances.build(:student_registration_id => reg.id, :session_date =>  session_date )
    end
  end
end
