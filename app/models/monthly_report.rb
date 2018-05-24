class MonthlyReport < ActiveRecord::Base
  include ReportBehavior

  validates :month, :num_hours_with_student, :num_preparation_hours, :student_goals,  :progress_notes, :presence => true
  validates_inclusion_of :goals_achieved, :in => [true, false]
  validates_inclusion_of :new_goals_set, :in => [true, false]
  before_create :set_year


def name
  "#{student_name} > #{Date::MONTHNAMES[month]} #{year}"
end

  private
  def set_year
    self.year = Date.today.year
  end
end
