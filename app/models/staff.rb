class Staff < ApplicationRecord
  validates :first_name, :last_name,  presence: true
  has_many :staff_attendances
  has_many :seasons, through: :season_staff


  def name
    "#{first_name} #{last_name}"
  end

  def thumbnail
    nil
  end
end
