class SessionReport < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :aep_registration
  has_one :student_registration, :through=> :aep_registration
  has_one :student, :through=> :student_registration
  attr_accessible :aep_registration_id, :worked_on_other, :session_date,:confirmed, 
    :worked_on, :preparation, :participation, :comprehension, :motivation, :comments
  delegate :name, :to =>:student, :prefix=> true 
  delegate :name, :to =>:tutor, :prefix=> true 

  validates :session_date, :worked_on, :preparation, :participation, :comprehension, :motivation, :presence => true

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


end
