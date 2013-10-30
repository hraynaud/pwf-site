class AepRegistration < ActiveRecord::Base
  FEE_STATUSES = ["Unpaid", "Waived", "Paid" ]

  belongs_to :season
  belongs_to :student_registration
  has_one :student, :through => :student_registration
  has_one :parent, :through => :student_registration
  has_many :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_one :year_end_report
  has_many :workshop_enrollments
  has_many :workshops, :through => :workshop_enrollments
  belongs_to :payment
  attr_accessible :student_registration_id, :learning_disability, 
    :learning_disability_details, :iep, :iep_details, :student_academic_contract, 
    :parent_participation_agreement, :transcript_test_score_release, :season_id, :payment_id, :payment_status
  delegate :name, :to => :student, :prefix => true
  delegate :age, :to => :student, :prefix => true
  delegate :term, :to => :season
  delegate :grade, :to => :student_registration
  as_enum :payment_status, FEE_STATUSES.each_with_index.map{|v, i| [v.parameterize.underscore.to_sym, i]}, :slim => :class

  validates :learning_disability_details, :presence => true, :if => :learning_disability?
  validates :iep_details, :presence => true, :if => :iep?
  scope :current, ->{where(season_id: Season.current_season_id)}
  scope :paid, where(payment_status_cd: payment_statuses(:paid, :waived))
  scope :unpaid, where(payment_status_cd: payment_statuses(:unpaid))
  before_create :set_season

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
