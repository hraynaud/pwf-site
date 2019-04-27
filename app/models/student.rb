class Student < ApplicationRecord
  belongs_to :parent
  has_one :co_parentship
  has_one :co_parent, through: :co_parentship

  has_many :student_registrations, dependent: :destroy
  has_one :current_registration, ->{joins(:season).where("seasons.current is true")}, class_name: "StudentRegistration", dependent: :destroy, inverse_of: :student
  has_many :attendances, :through => :student_registrations
  has_many :report_cards, :through => :student_registrations
  has_many :aep_registrations, :through => :student_registrations
  has_one  :current_aep_registration, ->{ joins(:season).where("seasons.current is true")}, class_name: "AepRegistrations"

  has_many :seasons, through: :student_registrations
  delegate :email, :primary_phone, :address, to: :parent
  has_one_attached :photo

  ETHNICITY = [ 
    "African American", "Latino", "Caucasion", "Asian",
    "South Asian" ,"Middle Eastern", "Native American", 
    "Pacififc Islander", "Other"
  ]

  accepts_nested_attributes_for :current_registration

  validates :first_name, :last_name, :gender, :dob, :ethnicity, :presence => :true

  delegate :grade, :school, :size, :medical_notes, :attendance_count, to: :current_registration, allow_nil: true

  scope :enrolled, ->{joins(:student_registrations).merge(StudentRegistration.confirmed)}
  scope :pending, ->{joins(:student_registrations).merge(StudentRegistration.pending)}
  scope :wait_listed, ->{joins(:student_registrations).merge(StudentRegistration.wait_list)}
  scope :withdrawn, ->{joins(:student_registrations).merge(StudentRegistration.withdrawn)}
  scope :in_aep, ->{joins(student_registrations: :aep_registration).merge(AepRegistration.paid)}

  scope :hs_seniors, ->{current.enrolled.where("student_registrations.grade = 12")}
  scope :by_last_first, ->{order("last_name asc, first_name asc")}



  def self.current
    self.includes(:parent, student_registrations: :season).joins(:parent).where(seasons: {current: true})
  end

  def name
    "#{first_name} #{last_name}"
  end

  def currently_registered?
    current_registration.present?
  end

  def current_present_attendances
    attendances.current.present
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

  def registration_by_season id
    student_registrations.by_season(id).first
  end

  def fully_enrolled?
    current_registration && current_registration.confirmed?
  end

  def is_pending?
    current_registration && current_registration.pending?
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

  def registered_last_year?
    student_registrations.confirmed.previous_season.any? ||
      student_registrations.wait_listed.previous_season.any?
  end

  def enrolled_last_season?
    student_registrations.confirmed.previous_season.any?
  end

  def previous_confirmed_registration
    student_registrations.confirmed.previous_season
  end

  def previous_registration
    student_registrations.previous_season.first
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



end

