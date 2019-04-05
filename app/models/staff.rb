class Staff < ApplicationRecord
  validates :first_name, :last_name,  presence: true
  has_many :staff_attendances, dependent: :destroy
  has_many :season_staffs, dependent: :destroy do 
    def current 
      where(season_id: Season.current.id).first
    end
  end
  
  has_many :seasons, through: :season_staffs

  def current_attendances
    staff_attendances.current
  end

  def current_present_attendances
    current_attendances.present
  end

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
