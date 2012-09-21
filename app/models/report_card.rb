class ReportCard < ActiveRecord::Base
  belongs_to :student_registration
  has_many :grades
end
