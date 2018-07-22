class StudentRegistration < ApplicationRecord
  belongs_to :season
  belongs_to :student
  belongs_to :payment, optional: true
  belongs_to :group, optional: true
  has_many :attendances
  has_many :grades
  has_many :aep_registrations
  has_many :report_cards
  has_one :parent, :through => :student

  before_create :set_status
  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates :student, :presence => true, :on => :save
  delegate :name, :dob, :gender, :age, :to => :student,:prefix => true
  delegate :id, :name, :to => :parent,:prefix => true
  delegate :term, to: :season

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  STATUS_VALUES = ["Pending", "Confirmed Fee Waived", "Confirmed Paid", "Wait List", "Withdrawn", "AEP Only"]
  as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  def self.current
    where(:season_id => Season.current_season_id)
  end

  def self.status_options
    statuses.hash
  end

  def self.size_options
    sizes.hash
  end

  def self.inactive
    where.not(id: current)
  end

  def self.current_confirmed
    @@current_confirmed = current.confirmed
  end

  def self.current_count
    current.count
  end

  def self.previous_season
    where(:season_id => Season.previous_season_id)
  end

  def self.by_season id
    where(season_id: id)
  end

  def self.unpaid
    pending
  end

  def self.paid
    confirmed_paid
  end

  def self.fee_waived
    confirmed_fee_waived
  end

  def self.confirmed
    confirmed_paid.or(confirmed_fee_waived)
  end

  def self.wait_listed
    wait_list
  end

  def self.current_wait_listed
    current.wait_listed
  end

  def self.current_wait_listed_count
    current_wait_listed.count
  end

  def self.wait_listed_count
    wait_listed.count
  end

  def self.with_valid_report_card
    where(report_card_submitted: true)
  end

  def self.ineligible
    where(report_card_submitted: false)
  end

  def self.order_by_student_last_name
    select(:first_name, :last_name).joins(:student).order("students.last_name asc, students.first_name asc")
  end

  def self.in_aep
    StudentRegistration.confirmed
      .joins("left outer join aep_registrations on student_registrations.id = aep_registrations.student_registration_id")
      .where("aep_registrations.id is not null")
  end

  def self.not_in_aep
    StudentRegistration.confirmed
      .joins("left outer join aep_registrations on student_registrations.id = aep_registrations.student_registration_id")
      .where("aep_registrations.id is null and student_registrations.season_id = ?", Season.current_season_id)
  end

  def paid?
    !payment_id.nil?
  end

  def season_description
    season.description
  end

  def active?
    season.is_current?
  end

  def student_name
    student.name
  end

  def unconfirmed?
    not confirmed?
  end

  def confirmed?
    ["confirmed_paid", "confirmed_fee_waived"].include? status
  end

  def mark_as_paid(payment)
    self.payment = payment
    self.status = :confirmed_paid 
    save!
  end

  def description
    "Fencing #{season.description}"
  end

  def fee
    season.fencing_fee
  end

  private


  def set_status
    if Season.current && Season.current.status == "Wait List"
      self.status = :wait_list
    else
      self.status = :pending 
    end
  end

end
