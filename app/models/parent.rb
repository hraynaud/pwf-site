class Parent < User
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :aep_registrations, :through => :student_registrations
  has_many :report_cards, :through => :student_registrations
  has_many :demographics
  has_one  :current_household_profile, -> {joins(:season).where("seasons.current is true")},  :class_name => "Demographic", validate: false
  has_one :contact_detail, foreign_key: :user_id, validate: false
  has_many :payments
  has_one_attached :photo

  attr_accessor :validate_user_fields_only

  with_options unless: :ignore_contact_household_validation? do |user|
    user.validates_associated :current_household_profile, on: :update
    user.validates_associated :contact_detail, on: :update
  end

  validates :keep_and_notify_if_waitlisted, presence: true, if: :should_show_wait_list_preferences?

  accepts_nested_attributes_for :contact_detail, update_only: true
  accepts_nested_attributes_for :current_household_profile, update_only: true


  scope :with_registrations, ->{joins(students: :student_registrations) }

  scope :by_student_registration_status, ->(status){with_registrations.merge(StudentRegistration.send(status)) }

  scope :with_previous_registrations, ->{ with_registrations.merge(StudentRegistration.previous_season) }

  scope :with_current_registrations, ->{ with_registrations.merge(StudentRegistration.current) }

  scope :with_confirmed_registrations, ->{ by_student_registration_status(:confirmed) }
 
  scope :with_current_confirmed_registrations, ->{ with_current_registrations.with_confirmed_registrations }

  scope :with_pending_registrations, ->{ by_student_registration_status(:pending) }

  scope :with_current_pending_registrations, ->{ with_current_registrations.with_pending_registrations }

  scope :with_wait_listed_registrations, ->{ by_student_registration_status(:wait_listed) }

  scope :with_current_wait_listed_registrations, ->{ with_current_registrations.with_wait_listed_registrations }
  scope :with_aep_registrations, ->{ with_registrations.merge(StudentRegistration.in_aep) }

  scope :with_unpaid_aep_registrations, ->{ with_registrations.merge(StudentRegistration.with_aep_unpaid) }

  scope :with_no_aep_registrations, -> { with_registrations.merge(StudentRegistration.not_in_aep)}

  scope :with_backlog_wait_listed_registrations, ->{with_wait_listed_registrations.where.not("students.id": with_current_confirmed_registrations.select("student_registrations.student_id"))}

  class << self
    def ordered_by_name
      select(:id, :first_name, :last_name).order('last_name asc, first_name asc')
    end

    def with_confirmed_registrations_count
      with_confirmed_registrations.count
    end

    def with_current_registrations_count
      with_current_registrations.count
    end
  end

  def ignore_contact_household_validation?
    validate_user_fields_only == "true"
  end

  def is_on_waitlist_backlog?
    wait_listed_registrations.size > 0
  end

  def should_update_contact_and_household_if_needed?
    !should_show_wait_list_preferences?
  end

  def should_show_wait_list_preferences?
    is_on_waitlist_backlog? && keep_and_notify_if_waitlisted.nil?
  end

  def current_confirmed_registrations_count
    confirmed_registrations.confirmed.count
  end

  def current_aep_registrations_count
    aep_registrations.current.count
  end

  def current_unpaid_aep_registrations_count 
    current_unpaid_aep_registrations.count
  end

  def current_unpaid_aep_registrations
    aep_registrations.current.unpaid
  end

  def wait_listed_registrations
    student_registrations.wait_listed.where.not("students.id": confirmed_registrations.select("student_registrations.student_id") )
  end

  def current_unpaid_aep_registration_amount
    current_unpaid_aep_registrations_count * Season.current.aep_fee
  end

  def has_unpaid_aep_registrations?
    current_unpaid_aep_registrations.count > 0
  end

  def students_count
    students.count
  end

  def student_by_id id
    students.find(id)
  end

  def registrations_count
    student_registrations.current.count
  end

  def unpaid_registrations_count
    unpaid_registrations.count
  end

  def unpaid_registrations
    student_registrations.current.unpaid
  end

  def confirmed_registrations
    student_registrations.current.confirmed
  end

  def confirmed_registrations_count
    confirmed_registrations.count
  end

  def withdrawn_registrations_count
    withdrawn_registrations.count
  end

  def withdrawn_registrations
    student_registrations.withdrawn
  end

  def has_current_unpaid_fencing_registrations?
    student_registrations.unpaid != []
  end

  def curr_registration_complete?
    current_household_profile.try(:valid?) && contact_detail.try(:valid?)
  end

  def has_household_profile_errors?
    current_household_profile.present? && current_household_profile.errors.any?
  end

  def has_household_profile_errors?
    current_household_profile.present? && current_household_profile.errors.any?
  end

  private

  #TODO could this be a student_registration valid?
  #IE prevent student reg from being created unless there is a current parent profile?
  def must_have_current_household_profile
    if  persisted? && !current_household_profile
       errors.add(:base, "Current demographic profile is out of date")
    end
  end

end
