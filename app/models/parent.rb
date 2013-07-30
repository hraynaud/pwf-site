class Parent < ActiveRecord::Base
  has_one  :user, :as => :profileable
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :demographics
  has_one  :current_household_profile, :class_name => "Demographic", :conditions=> proc {["demographics.season_id = ?", Season.current.id]}
  has_many :payments

  attr_writer :current_step

  accepts_nested_attributes_for :demographics, :user
  attr_accessible :demographics_attributes, :user_attributes

  validate :must_have_current_household_profile, :on => :update
  validates_associated :user
  delegate :email, :name, :first_name, :last_name, :address1, :address2, 
    :city, :state, :zip, :primary_phone, :secondary_phone, :other_phone,
    :full_address, :password,
    :to => :user

  #TODO This scope format below is more efficient but a bug in AA prevents it use. When the next release is available change the scope
  #scope :with_current_registrations, joins(:student_registrations).where("student_registrations.season_id = ?", Season.current.id).group("parents.id")
  # scope :with_current_registrations, includes(:student_registrations).where("student_registrations.season_id = ?", Season.current.id)

  def registration_complete?
    address1 && city && state && zip && primary_phone
  end

  def self.with_current_registrations
    includes(:student_registrations).where("student_registrations.season_id = ?", Season.current.id)
  end

  def self.pending
    includes(:student_registrations).where("student_registrations.status_cd = ?", StudentRegistration.statuses["Pending"])
  end

  def self.paid
    includes(:student_registrations).where("student_registrations.status_cd = ?", StudentRegistration.statuses["Confirmed Paid"])
  end

  def has_unpaid_pending_registrations?
    student_registrations.current.unpaid != []
  end

  def current_unpaid_pending_registrations
    student_registrations.current.unpaid
  end

  def has_current_student_registrations?
    current_student_registrations != []
  end

  def self.with_current_registrations_count
    with_current_registrations.count
  end

  def steps
    %w[account contact demographics]
  end

  def current_step
    @current_step || steps.first
  end

  def current_step_index
    steps.index(current_step)
  end

  def friendly_current_step_index
    current_step_index + 1
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end



  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step| #NOTE: cool ruby-foo all? http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-all-3F
      self.current_step = step
      valid?
    end
  end

  private

  def on_contact_step?
    current_step == "contact"
  end

  def on_demographics_step?
    current_step == "demographics"
  end

  def should_validate_household?
    Season.current
  end

  def must_have_current_household_profile
    if current_household_profile.nil?
      errors.add(:base, "Current demographic profile is out of date")
    end
  end



end

