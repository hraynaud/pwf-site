class GradeFormat < ActiveRecord::Base
  attr_accessible :grade_type, :name, :strategy, :grade_converters_attributes
  has_many :grade_converters
  accepts_nested_attributes_for :grade_converters, allow_destroy: true
end
