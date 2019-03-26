ActiveAdmin.register Attendance do
  menu false
  permit_params :attended, :student_registration_id, :attendance_sheet_id

end
