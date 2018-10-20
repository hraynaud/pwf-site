class Subject < ApplicationRecord
	has_many :grades
	has_many :tutoring_assignments
end
