class StudentAssessment < ActiveRecord::Base
  attr_accessible :aep_registration_id, :post_test_date, :post_test_grade, :pre_test_date, :pre_test_grade
  belongs_to :aep_registration
  has_one :student, through: :aep_registration
  delegate :name, to: :student, prefix: true
end
