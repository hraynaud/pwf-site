class Student < ApplicationRecord
  belongs_to :parent

  has_many :student_registrations
  has_one :current_registration, ->{ joins(:season).where("seasons.current is true")}, class_name: "StudentRegistration"
  has_many :attendances, :through => :student_registrations

  has_many :aep_registrations, :through => :student_registrations
  has_one  :current_aep_registration, ->{ joins(:season).where("seasons.current is true")}, class_name: "AepRegistrations"

  ETHNICITY = [ 
    "African American", "Latino", "Caucasion", "Asian",
    "South Asian" ,"Middle Eastern", "Native American", 
    "Pacififc Islander", "Other"
  ]

  attr_accessor :avatar_changed

  accepts_nested_attributes_for :student_registrations
  validates :first_name, :last_name, :gender, :dob, :ethnicity, :presence => :true

  after_save :schedule_image_processing, :if => :avatar_image_changed
  delegate :grade, :school, :size, :medical_notes, :attendance_count, to: :current_registration, allow_nil: true

  def self.current
    self.includes(:parent, student_registrations: :season).joins(:parent).where(seasons: {current: true})
  end

  def name
    "#{first_name} #{last_name}"
  end

  def currently_registered?
    current_registration.present?
  end

  def registration_status
    if current_registration
      current_registration.status.to_s.titleize
    else
      "Not Registered"
    end
  end

  def current_registration_or_new
    current_registration || student_registrations.build(season_id: Season.current.id)
  end

  def fully_enrolled?
    current_registration && current_registration.confirmed?
  end

  def current_aep_registration
    aep_registrations.current.first
  end

  def currently_in_aep?
    !current_aep_registration.nil?
  end

  def aep_only?
    current_registration.status == :aep_only
  end

  def aep_eligible?
    !current_aep_registration && (current_registration.confirmed? || aep_only?)
  end

  #TODO clean this up
  def registered_last_year?
    student_registrations.confirmed.previous_season.count > 0 || 
      student_registrations.wait_listed.previous_season.count > 0
  end

  def enrolled_last_season
    student_registrations.confirmed.previous_season.count > 0
  end

  def previous_registration
    student_registrations.confirmed.previous_season.first
  end

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def schedule_image_processing
    #Delayed::Job.enqueue AvatarProcessJob.new(self.id)
  end

  def pronoun
    gender == "M" ? "him" : "her"
  end

  private 

  def avatar_image_changed
    avatar_changed?
  end


end

