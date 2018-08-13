class Parent < User
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :aep_registrations, :through => :student_registrations
  has_many :report_cards, :through => :student_registrations
  has_many :demographics
  has_one  :current_household_profile, -> {where("demographics.season_id = ?", Season.current.id)},:class_name => "Demographic" 
  has_many :payments

  attr_accessor :avatar_changed

  scope :with_current_registrations, ->{
    joins(:students)
      .joins(:student_registrations)
      .merge(StudentRegistration.current).distinct
  }

  def self.by_status status
    with_current_registrations.merge(StudentRegistration.send(status))
  end

  def self.ordered_by_name
    select(:id, :first_name, :last_name).order('last_name asc, first_name asc')
  end

  def self.with_pending_registrations
    by_status :unpaid
  end

  def self.with_paid_registrations
    by_status :paid
  end

  def self.with_confirmed_registrations
    by_status :confirmed
  end

  def self.with_wait_listed_registrations
    by_status :wait_listed
  end

  def self.with_current_registrations_count
    with_current_registrations.count
  end

  def self.with_current_aep_registrations
    with_current_registrations.joins(:aep_registrations).where("aep_registrations.season_id = ?", Season.current.id).references(:aep_registrations)
  end

  def self.not_in_aep
    StudentRegistration.not_in_aep.joins(:parent).map(&:parent).uniq.sort_by{|p|p.name}
  end

  def self.in_aep
    StudentRegistration.in_aep.joins(:parent).map(&:parent).uniq.sort_by{|p|p.name}
  end

  def unpaid_fencing_registration_amount
    current_unpaid_registrations_count * Season.current.fencing_fee
  end

  def current_unpaid_registrations_count 
    current_unpaid_registrations.count
  end

  def current_unpaid_aep_registrations_count 
    current_unpaid_registrations.count.count
  end

  def unpaid_aep_registration_amount
    current_unpaid_aep_registrations_count * Season.current.aep_fee
  end

  def current_unpaid_aep_registrations_count 
    current_unpaid_aep_registrations.count
  end

  def registration_complete?
    address1 && city && state && zip && primary_phone
  end

  def has_unpaid_pending_registrations?
    student_registrations.current.unpaid != []
  end

  def has_only_ineligble_registrations?
    regs = student_registrations.current.unpaid
    regs !=[] && has_unpaid_pending_ineligible_registrations?
  end

  def has_unpaid_pending_valid_registrations?
    student_registrations.current.unpaid.with_valid_report_card != []
  end

  def has_no_unpaid_pending_ineligible_registrations?
   !has_unpaid_pending_ineligible_registrations?
  end

  def has_unpaid_pending_ineligible_registrations?
    student_registrations.current.unpaid.ineligible != []
  end

  def has_unpaid_aep_registrations?
    current_unpaid_aep_registrations.count > 0
  end

  def current_unpaid_registrations
    current_student_registrations.unpaid
  end

  def current_confirmed_registrations
    current_student_registrations.confirmed
  end

  def current_confirmed_registrations_count
    current_confirmed_registrations.count
  end

  def current_eligible_unpaid_registrations
    current_unpaid_registrations.with_valid_report_card
  end

  def current_unpaid_aep_registrations
    aep_registrations.current.unpaid
  end

  def has_current_student_registrations?
    current_student_registrations != []
  end

  def has_current_aep_registration?
    aep_registrations != []
  end

  def current_registrations_count
    current_student_registrations.count
  end

  def current_withdrawn_registrations_count
    current_withdrawn_registrations.count
  end

  def current_withdrawn_registrations
    current_student_registrations.withdrawn
  end

 def current_student_registrations
   student_registrations.current
 end

  def students_count
    students.count
  end

  def student_by_id id
    students.find(id)
  end

  private

  def should_validate_household?
    Season.current
  end

  #TODO could this be a student_registration valid?
  #IE prevent student reg from being created unless there is a current parent profile?
  def must_have_current_household_profile
    if  persisted? && !current_household_profile
       errors.add(:base, "Current demographic profile is out of date")
    end
  end


  def avatar_image_changed
    avatar_changed?
  end


end
