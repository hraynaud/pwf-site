class AttendanceSheet < ApplicationRecord
  has_many :attendances, ->{includes :student_registration}, :dependent => :destroy
  belongs_to :season

  accepts_nested_attributes_for :attendances

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date
  delegate :term, to: :season
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

  def generate_attendances
    Attendance.import build_attendances
  end

  def current_students
    attendances.map do |a|
      {attendanceId: a.id, name: a.student_name, attended: a.attended, studentId: a.student_registration_id, groupId: a.group_id}
    end
  end

  def as_json options
    {id: id, date: session_date, students: attendences_for_sheet}
  end

  def attendences_for_sheet
    attendances.with_students.ordered.as_json({})
  end

  private

  def build_attendances
    StudentRegistration.current_confirmed.map do |reg|
      attendances.build(:student_registration_id => reg.id, :session_date =>  session_date )
    end
  end
end
