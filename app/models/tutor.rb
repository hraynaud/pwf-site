class Tutor < ActiveRecord::Base
  include UserBehavior
  mixin_user

  has_many :tutoring_assignments
  has_many :aep_registrations, through: :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_many :year_end_reports
  attr_accessible :returning, :occupation, :emergency_contact_name, :emergency_contact_primary_phone, :emergency_contact_secondary_phone, :emergency_contact_relationship, :season_id 
end
