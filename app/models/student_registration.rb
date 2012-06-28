class StudentRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student
  belongs_to :parent
  accepts_nested_attributes_for :student

  attr_accessible :student_attributes,:school, :grade, :size_cd, :medical_notes, :academic_notes, :academic_assistance

  validates :student, :season, :school, :grade, :size_cd, :presence => :true

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}
end
