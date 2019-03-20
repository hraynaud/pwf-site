class StaffAttendanceSheet < ApplicationRecord
  belongs_to :season
  has_many :staff_attendances

  after_create :create_staff_attendances



  def as_json options
    {id: id, date: session_date, attendees: attendances_for_sheet}
  end

  def attendances_for_sheet
    staff_attendances.includes(:staff).as_json({})
  end

  def formatted_session_date
    session_date.strftime("%B-%d-%Y")
  end

  private

  def create_staff_attendances
    Season.current.staffs.each do |staff|
      StaffAttendance.create(staff_id: staff.id, staff_attendance_sheet_id: self.id)
    end
  end
end
