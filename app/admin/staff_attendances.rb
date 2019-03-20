ActiveAdmin.register StaffAttendance do
  belongs_to :staff_attendance_sheet
  permit_params :attended
end
