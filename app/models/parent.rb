class Parent < ActiveRecord::Base
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :demographics
  has_one  :current_household_profile, :class_name => "Demographic", :conditions=> proc {["demographics.season_id = ?", Season.current.id]}
  has_many :payments
  accepts_nested_attributes_for :demographics

  devise :database_authenticatable, :registerable,:recoverable, :validatable

  attr_writer :current_step
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, 
    :address1, :address2, :city, :state, :zip, :primary_phone, :secondary_phone, 
    :other_phone, :demographics_attributes

  validates :first_name, :last_name, :address1, :city, :state, :zip, :primary_phone,  :presence => true, :if => :on_contact_step?
  validates :primary_phone, :format => {:with =>/\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :if => :on_contact_step?
  validates :secondary_phone, :other_phone, :format => {:with => /\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :allow_blank => true
  validates :current_household_profile, :presence => true, :if => :should_validate_household?
  # validate :all_valid?, :on => :save

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

  def name
    "#{first_name} #{last_name}"
  end

  def has_unpaid_pending_registrations?
    student_registrations.current.unpaid != []
  end

  def current_unpaid_pending_registrations
    student_registrations.current.unpaid
  end

  def full_address
    "#{address1} #{address2} #{city} #{state} #{zip}"
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
    res = steps.all? do |step| #NOTE: cool ruby-foo all? http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-all-3F
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
    if Season.current
       on_demographics_step?
    end
  end



end

