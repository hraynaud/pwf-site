class StudentRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student
  belongs_to :payment
  belongs_to :group
  has_many :attendances
  has_many :grades
  has_many :aep_registrations
  has_many :report_cards
  has_one :parent, :through => :student
  attr_accessible :school, :grade, :size_cd, :medical_notes, 
    :academic_notes, :academic_assistance, :student_id, :season_id, 
    :status_cd, :first_report_card_received, :first_report_card_expected_date, 
    :first_report_card_received_date, :second_report_card_received, 
    :second_report_card_expected_date, :second_report_card_received_date,
    :report_card_exempt 

  before_create :set_status
  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates :student, :presence => true, :on => :save
  delegate :name, :dob, :gender, :age, :to => :student,:prefix => true
  delegate :id, :name, :to => :parent,:prefix => true
  delegate :term, to: :season

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  STATUS_VALUES = ["Pending", "Confirmed Fee Waived", "Confirmed Paid", "Wait List", "Withdrawn", "AEP Only"]
  as_enum :status, STATUS_VALUES.each_with_index.map{|v, i| [v.parameterize.underscore.to_sym, i]}

  def self.by_season id
    where(season_id: id)
  end

  def self.with_valid_report_card
    where(report_card_submitted: true)
  end
  
  def self.ineligible
    where(report_card_submitted: false)
  end

  def self.order_by_student_last_name
    self.joins(:student).order("students.last_name asc, students.first_name asc")
  end
  
  def self.in_aep
   StudentRegistration.enrolled
   .joins("left outer join aep_registrations on student_registrations.id = aep_registrations.student_registration_id")
   .where("aep_registrations.id is not null")
 end

  def self.not_in_aep
   StudentRegistration.enrolled
   .joins("left outer join aep_registrations on student_registrations.id = aep_registrations.student_registration_id")
   .where("aep_registrations.id is null and student_registrations.season_id = ?", Season.current_season_id)
 end

 def self.unpaid
    where(status_cd: statuses.pending)
  end

  def self.paid
    where(status_cd: statuses.confirmed_paid)
  end

  def self.fee_waived
    where(status_cd: statuses.confirmed_fee_waived)
  end

  def self.enrolled
    where(status_cd: statuses(:confirmed_fee_waived, :confirmed_paid))
  end

  def self.wait_listed
    where(status_cd: statuses.wait_list)
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

  def self.current
    where(:season_id => Season.current_season_id)
  end

  def self.previous_season
    where(:season_id => Season.previous_season_id)
  end

  def self.current_count
    current.count
  end

  def self.inactive
    where("season_id != ?",Season.current.id)
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
    self.class.statuses.except(:confirmed_fee_waived, :confirmed_paid).include? status
  end

  def confirmed
    !unconfirmed?
  end

  def mark_as_paid(payment)
    self.payment = payment
    self.status = :confirmed_paid 
    save!
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
