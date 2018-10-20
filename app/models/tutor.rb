class Tutor < ApplicationRecord
  include UserBehavior
  mixin_user

  has_many :tutoring_assignments
  has_many :aep_registrations, through: :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_many :year_end_reports
  def self.order_by_last_name
    self.joins(:user).order("users.last_name asc, users.first_name asc")
  end
end
