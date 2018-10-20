class Workshop < ApplicationRecord
  belongs_to :tutor
  belongs_to :season
  has_many :workshop_enrollments
  has_many :aep_registrations, :through => :workshop_enrollments
  before_save :set_season
  #delegate :name, :to => :tutor, :prefix => true
  scope :current, where(:season_id =>Season.current_season_id)

  def set_season
    self.season = Season.current
  end 
  def tutor_name
    tutor.try(:name) || "Pending"
  end
end
