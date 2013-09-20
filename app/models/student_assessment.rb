class StudentAssessment < ActiveRecord::Base
  attr_accessible :aep_registration_id, :post_test_date, :post_test_grade, :pre_test_date, :pre_test_grade
end
