class Attendance < ActiveRecord::Base
  belongs_to :attendance_sheet
  belongs_to :student_registration, :include => :student

  validates_uniqueness_of :student_registration_id, :scope=>[:session_date, :attendance_sheet_id]
end
