class MonthlyReport < ActiveRecord::Base
  include ReportBehavior
  attr_accessible :aep_registration_id, :goals_achieved, :issues_concerns, :issues_resolution, 
    :month, :new_goals_desc, :new_goals_set, :num_preparation_hours,
    :student_goals, :tutor_id,:num_hours_with_student, :progress_notes, :confirmed 

  validates :aep_registration_id, :month,  :tutor_id, :num_hours_with_student, :num_preparation_hours, :student_goals,  :progress_notes, :presence => true
  validates_inclusion_of :goals_achieved, :in => [true, false]
  validates_inclusion_of :new_goals_set, :in => [true, false]
  before_create :set_year




  private
  def set_year
    self.year = Date.today.year
  end
end
