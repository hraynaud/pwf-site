class AttendanceSheet < ApplicationRecord
  belongs_to :season
  has_many :student_attendances, ->{includes :student_registration}, :dependent => :destroy, class_name: "Attendance"
  has_many :staff_attendances, ->{includes :staff}, :dependent => :destroy

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date
  delegate :term, to: :season

  scope :current, ->{where(season_id: Season.current.id)}

  attr_accessor :attendee_type
  accepts_nested_attributes_for :student_attendances

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

  def unattached_students
    StudentRegistration.current_confirmed.joins(:student).select("first_name, last_name, student_registrations.id").where.not(id: Attendance.select("student_registration_id").where(attendance_sheet_id: id))
  end

  def unattached_staff
    Staff.current.select("first_name, last_name, staffs.id").where.not(id: StaffAttendance.select("staff_id").where(attendance_sheet_id: id))
  end

  def generate_attendances
    build_student_attendances
    build_staff_attendances
  end

  def as_json options
    {id: id, 
     date: session_date, 
     students: student_attendances_as_json, 
     staff: staff_attendances_as_json, 
     unattachedStudents: unattached_as_json(unattached_students),
     unattachedStaff: unattached_as_json(unattached_staff)
    }
  end

  def formatted_session_date
    session_date.strftime("%B-%d-%Y")
  end

  private

  def unattached_as_json group
    group.map do |person|
      {
        id: nil,
        userid: person.id,
        name: "#{person.first_name} #{person.last_name}",
        thumbnail: nil,
        attended: nil
      }
    end
  end

  def student_attendances_as_json
    attendances.ordered.as_json({})
  end

  def staff_attendances_as_json
    staff_attendances.ordered.as_json({})
  end

  def attendance_by_type
    attendee_type == "staff" ? staff_attendances : student_attendances.with_student
  end

  def build_student_attendances
    Attendance.import new_student_attendances
  end

  def new_student_attendances
    StudentRegistration.current_confirmed.map do |reg|
      attendances.build(:student_registration_id => reg.id )
    end
  end

  def build_staff_attendances
    SeasonStaff.current.map do |staff|
      staff_attendances.create(:staff_id => staff.staff_id, attended: false )
    end
  end
end
