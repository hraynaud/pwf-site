class AepRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student_registration
  has_one :student, :through => :student_registration
  has_one :parent, :through => :student_registration
  has_many :tutoring_assignments
  has_many :session_reports
  has_many :monthly_reports
  has_one :year_end_report
  belongs_to :payment
  attr_accessible :student_registration_id, :learning_disability, :learning_disability_details, :iep, :iep_details, :student_academic_contract, :parent_participation_agreement, :transcript_test_score_release
  delegate :name, :to => :student, :prefix => true
  validates :learning_disability_details, :presence => true, :if => :learning_disability?
  validates :iep_details, :presence => true, :if => :iep?
  scope :current, ->{where(season_id: Season.current_season_id)}

  before_create :set_season

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
