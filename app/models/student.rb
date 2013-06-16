class Student < ActiveRecord::Base
  belongs_to :parent
  has_many :student_registrations
  has_many :attendances, :through => :student_registrations
  attr_accessible :student_registrations_attributes, :first_name, :last_name, :gender, :dob, :parent_id
  accepts_nested_attributes_for :student_registrations

  has_one  :current_registration, :class_name => "StudentRegistration", :conditions=> proc {["student_registrations.season_id = ?", Season.current_season_id]}
  has_one  :current_confirmed_registration, :class_name => "StudentRegistration",
    :conditions=> proc {["student_registrations.status_cd = ? AND student_registrations.season_id = ?",StudentRegistration.statuses("Confirmed Paid"), Season.current_season_id]}
  validates :first_name, :last_name, :gender, :dob, :presence => :true

  def name
    "#{first_name} #{last_name}"
  end

  def currently_registered?
    !current_registration.nil?
  end

  def self.current
    joins(:student_registrations).where('student_registrations.season_id = ?', Season.current_season_id)
  end

  def self.registered_last_season
    joins(:student_registrations).where('student_registrations.season_id = ?', Season.previous_season_id)
  end

  def registration_status
    if current_registration
      current_registration.status
    else
      "Not Registered"
    end
  end

  def registered_last_year?
    student_registrations.enrolled.previous_season.count > 0 || 
    student_registrations.wait_listed.previous_season.count > 0
  end

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def pronoun
    gender == "M" ? "him" : "her"
  end
end

