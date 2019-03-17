class StaffAttendance < ApplicationRecord
  belongs_to :staff
  belongs_to :staff_attendance_sheet
end
