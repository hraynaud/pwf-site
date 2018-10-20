class GradeFormat < ApplicationRecord
  has_many :grade_converters
  accepts_nested_attributes_for :grade_converters, allow_destroy: true
end
