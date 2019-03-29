class SeasonStaff < ApplicationRecord
  belongs_to :staff
  belongs_to :season
  scope :current, ->{where(season_id: Season.current.id)}
  delegate :name, :first_name, to: :staff
end
