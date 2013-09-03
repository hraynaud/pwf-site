class MonthlyReport < ActiveRecord::Base
  attr_accessible :aep_registration_id, :goals_achieved, :issues_concerns, :issues_resolution, 
    :month, :new_goals_desc, :new_goals_set, :num_preparation_hours,
    :student_goals, :tutor_id,:num_hours_with_student, :progress_notes, :confirmed 
  belongs_to :tutor
  belongs_to :aep_registration
  belongs_to :tutor
  has_one :student_registration, :through=> :aep_registration
  has_one :student, :through=> :student_registration

  validates :aep_registration_id, :month,  :tutor_id, :num_hours_with_student, :num_preparation_hours, :student_goals,  :progress_notes, :presence => true
  validates_inclusion_of :goals_achieved, :in => [true, false]
  validates_inclusion_of :new_goals_set, :in => [true, false]
  delegate :name, :to =>:student, :prefix=> true 
  delegate :name, :to =>:tutor, :prefix=> true 
  before_create :set_year



  private
  def set_year
    self.year = Date.today.year
  end
end
