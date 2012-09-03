class AttendanceSheet < ActiveRecord::Base
  has_many :attendances, :include => :student_registration
  attr_accessible :session_date, :attendances_attributes
  accepts_nested_attributes_for :attendances
end
