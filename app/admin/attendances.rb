ActiveAdmin.register Attendance do
  belongs_to :attendance_sheet
  permit_params :attended
end
