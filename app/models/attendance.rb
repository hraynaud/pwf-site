class Attendance < ActiveRecord::Base
  belongs_to :attendance_sheet
  belongs_to :student_registration, :include => :student
end
