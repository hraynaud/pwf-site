class Student < ActiveRecord::Base
  belongs_to :parent
  has_many :student_registrations
  has_many :attendances, :through => :student_registrations
  has_one  :current_registration, :class_name => "StudentRegistration", :conditions=> proc {["student_registrations.season_id = ?", Season.current_season_id]}
  has_one  :current_confirmed_registration, :class_name => "StudentRegistration",
    :conditions=> proc {["student_registrations.status_cd in (?) AND student_registrations.season_id = ?",StudentRegistration.statuses(:confirmed_paid,:confirmed_fee_waived), Season.current_season_id]}
  has_many :aep_registrations, :through => :current_confirmed_registration
  has_one  :current_aep_registration, :class_name => "AepRegistrations", :conditions=> proc {"aep_registrations.season_id =  #{Season.current_season_id}"}
 
  ETHNICITY = ["African American", "Latino", "Caucasion", "Asian", "South Asian","Middle Eastern", "Native American", "Pacififc Islander", "Other"]

  mount_uploader :avatar, AvatarUploader
  attr_accessor :avatar_changed

  attr_accessible :student_registrations_attributes, :first_name, :last_name, :ethnicity, :gender, :dob, :parent_id, :avatar, :avatar_cache, :avatar_changed
  accepts_nested_attributes_for :student_registrations
  validates :first_name, :last_name, :gender, :dob, :ethnicity, :presence => :true

  after_save :schedule_image_processing, :if => :avatar_image_changed

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
      current_registration.status.to_s.titleize
    else
      "Not Registered"
    end
  end

  def fully_enrolled?
    current_registration && (current_registration.confirmed_paid? || current_registration.confirmed_fee_waived?)
  end

  def current_aep_registration
    aep_registrations.current.first
  end

  def currently_in_aep?
    !current_aep_registration.nil?
  end

  def aep_eligible?
    !current_aep_registration && current_confirmed_registration
  end

  def registered_last_year?
    student_registrations.enrolled.previous_season.count > 0 || 
      student_registrations.wait_listed.previous_season.count > 0
  end

  def enrolled_last_season
    student_registrations.enrolled.previous_season.count > 0
  end


  def previous_registration
    student_registrations.enrolled.previous_season.first
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

