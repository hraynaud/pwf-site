class Tutor < ActiveRecord::Base
  include UserBehavior
  mixin_user

  has_many :tutoring_assignments
  has_many :aep_registrations, through: :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_many :year_end_reports
end
