class AepRegistration < ApplicationRecord

  belongs_to :student_registration
  belongs_to :payment, optional: true 
  has_one :season, :through => :student_registration
  has_one :student, :through => :student_registration
  has_one :parent, :through => :student_registration
  has_many :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_one :year_end_report
  has_many :workshop_enrollments
  has_many :workshops, :through => :workshop_enrollments
  delegate :name, :to => :student, :prefix => true
  delegate :age, :to => :student, :prefix => true
  delegate :term, :to => :season
  delegate :grade, :to => :student_registration

  validates :student_registration, :presence => true
  validates :learning_disability_details, :presence => true, :if => :learning_disability?
  validates :iep_details, :presence => true, :if => :iep?
  scope :current, ->{where(season_id: Season.current_season_id)}
  scope :paid, ->{where(payment_status_cd: payment_statuses(:paid, :waived))}
  scope :unpaid, ->{where(payment_status_cd: payment_statuses(:unpaid))}
  before_create :set_season

  STATUS_VALUES = ["Unpaid", "Waived", "Paid"]
  as_enum :payment_status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  def mark_as_paid(payment)
    self.payment = payment
    self.paid!
    save!
  end

 def self.current_students
     current.map do |reg| 
      {aepRegId: reg.id, name: reg.student_name, paid: reg.payment_status}
    end
  end

  def self.order_by_student_last_name
    self.joins(:student).order("students.last_name asc, students.first_name asc")
  end

  def self.current
    where(:season_id => Season.current_season_id)
  end

  def description
    "AEP #{student_name}-#{season.slug}"
  end

  def fee
    season.aep_fee
  end

  private

  def set_season
    self.season_id = student_registration.try(:season_id) || Season.current_season_id
  end

  def complete?
    valid? && paid? && 
      student_academic_contract? &&
      parent_participation_agreement? &&
      transcript_test_score_release?
  end

  def paid?
    !payment.nil?
  end

end
