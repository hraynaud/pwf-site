class Season < ActiveRecord::Base
  has_many :student_registrations
  has_many :students, :through => :student_registrations
end

