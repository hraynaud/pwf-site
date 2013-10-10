class Subject < ActiveRecord::Base
	has_many :grades
	has_many :tutoring_assignments
	default_scope order('name ASC')
end
