class Staff < ApplicationRecord
  validates :first_name, :last_name,  presence: true
  has_many :staff_attendances
  has_many :season_staffs
  has_many :seasons, through: :season_staffs


  def name
    "#{first_name} #{last_name}"
  end

  def self.current
    joins(:season_staffs).where("season_staffs.season_id = ?", Season.current.id)
  end

  def thumbnail
    nil
  end
end
