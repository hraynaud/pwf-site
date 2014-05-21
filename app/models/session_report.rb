class SessionReport < ActiveRecord::Base
  include ReportBehavior
  attr_accessible :aep_registration_id, :worked_on_other, :session_date,:confirmed, 
    :worked_on, :preparation, :participation, :comprehension, :motivation, :comments

  validates :session_date, :tutoring_assignment_id, :worked_on, :preparation, :participation, :comprehension, :motivation,  :presence => true

  WORKED_ON= ["Clarification of Concepts", "Homework Assistance", "Essay Organization", "Writing Concerns", "Exam Preparation", "Project Planning", "Other" ]
  PREPARATION= ["Well Prepared", "Prepared", "Not Prepared" ]
  PARTICIPATION= ["Excellent", "Good", "Adequate", "None" ]
  COMPREHENSION= ["Excellent", "Good", "Some", "None" ]
  MOTIVATION= ["Excellent", "Good", "Somewhat", "Not Motivated" ]

  EVALUATION_VALS = {
    worked_on: WORKED_ON,
    preparation: PREPARATION,
    participation: PARTICIPATION,
    comprehension: COMPREHENSION,
    motivation: MOTIVATION
  }

  EVALUATION_VALS.each do|key, values|
    as_enum key, values.each_with_index.map{|v, i| [v.parameterize.underscore.to_sym, i]}
  end

  def name
     "#{student_name}: #{session_date.strftime('%h-%d-%Y')}"
  end

end
