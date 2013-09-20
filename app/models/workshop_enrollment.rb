class WorkshopEnrollment < ActiveRecord::Base
  belongs_to :workshop
  belongs_to :aep_registration
  has_one :student, :through => :aep_registration
  attr_accessible :status_cd, :workshop_id, :aep_registration_id


  scope :by_aep_reg, ->(id){where(:student_registration_id =>id)}
  scope :current, where(:season_id =>Season.current_season_id)
  delegate :name, to: :workshop, prefix: true
  delegate :name, to: :student, prefix: true
  as_enum :status,  [:pending, :approved, :denied]
end
