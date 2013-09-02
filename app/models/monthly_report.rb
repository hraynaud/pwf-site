class MonthlyReport < ActiveRecord::Base
  attr_accessible :aep_registration_id, :goals_achieved, :hours_with_student, :issues_concerns, :issues_resolution, :month, :new_goals_desc, :new_goals_set, :num_preparation_hours, :progress_comments, :student_goals, :tutor_id, :year
end
