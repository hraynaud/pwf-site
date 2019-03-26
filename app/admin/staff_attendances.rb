ActiveAdmin.register StaffAttendance do
  menu false
  permit_params :attended, :staff_id, :attendance_sheet_id
end
