class Season < ActiveRecord::Base
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  validates :fall_registration_open, :beg_date, :end_date, :description, :presence => true

  as_enum :status, ["Open", "Wait List", "Closed"]

  def is_current?
    Time.now.between?(fall_registration_open, end_date)
  end

  def self.current
    today = Time.now
    where("? >= fall_registration_open AND ? <= end_date",today,today).first
  end

  def description
    "Fall #{beg_date.year}-Spring #{end_date.year}"
  end

  alias :name :description
end

