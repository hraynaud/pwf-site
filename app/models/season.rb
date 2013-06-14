class Season < ActiveRecord::Base
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  has_many :payments
  validates :fall_registration_open, :beg_date, :end_date, :presence => true

  as_enum :status, ["Open", "Wait List", "Closed"]

  def is_current?
    Time.now.between?(fall_registration_open, end_date)
  end

  def self.current
    today = Time.now
    # Season.find(:first, :conditions => ["? >= fall_registration_open AND ? <= end_date",today,today] )
    where(:current => true).first
  end

  def self.current_season_id
    current.id
  end

  def description
    "Fall #{beg_date.year}-Spring #{end_date.year}" unless new_record?
  end

  alias :name :description
end

