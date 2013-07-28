class Parent < ActiveRecord::Base
  has_one  :user, :as => :profileable
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :demographics
  has_one  :current_household_profile, :class_name => "Demographic", :conditions=> proc {["demographics.season_id = ?", Season.current.id]}
  has_many :payments
  accepts_nested_attributes_for :demographics
  attr_accessible :demographics_attributes

  validate :must_have_current_household_profile, :on => :update
  delegate :email, :name, :first_name, :last_name, :address1, :address2, 
    :city, :state, :zip, :primary_phone, :secondary_phone, :other_phone,
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

  private

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

