class StudentRegistration < ApplicationRecord

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  STATUS_VALUES = ["Pending", "Confirmed Fee Waived", "Confirmed Paid", "Wait List", "Withdrawn", "AEP Only", "Blocked On Report Card"]
  as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  belongs_to :season
  belongs_to :student, inverse_of: :current_registration
  belongs_to :payment, optional: true
  belongs_to :group, optional: true

  has_many :attendances, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_one :aep_registration, dependent: :destroy
  has_one :fall_winter_report_card,  ->{where("marking_period_id = ?", MarkingPeriod.first_session_id)}, class_name: "ReportCard"
  has_one :spring_summer_report_card,  ->{where("marking_period_id = ?", MarkingPeriod.second_session_id)}, class_name: "ReportCard"
  has_one :parent, :through => :student

  before_create :determine_status

  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates_uniqueness_of :student, scope: :season, message: "This student is already registered"
  validates :student, :presence => true, :on => :save

  delegate :name, :first_name, :last_name, :dob, :gender, :age, :to => :student,:prefix => true
  delegate :id, :name, :email, :first_name,  :to => :parent,:prefix => true
  delegate :term, to: :season

  scope :report_card_required, ->{where(report_card_exempt: false)}
  scope :report_card_exempt, ->{where(report_card_exempt: true)}
  scope :with_aep, ->{joins(:aep_registration)}
  scope :with_aep_paid, ->{with_aep.merge(AepRegistration.confirmed)}
  scope :with_aep_unpaid, ->{with_aep.current.confirmed.merge(AepRegistration.unpaid)}
  scope :in_aep, ->{with_aep_paid.current.confirmed}
  scope :not_in_aep, -> { where.not(id: in_aep)}
  scope :exclude_selected, ->(exclude_list) { where.not(id: exclude_list)}

  scope :with_unsubmitted_transcript_for, ->(marking_period){
    StudentRegistration.includes(:student)
      .current.confirmed.includes(marking_period)
      .references(marking_period)
      .where('report_cards.id is null' )
  }

  scope :hs_seniors, ->{confirmed.where("student_registrations.grade = 12")}

  class << self

    def sizes_table
      sizes.hash.invert
    end

    def missing_report_card_for term
      term_id = "#{term}_report_card".to_sym
      with_unsubmitted_transcript_for(term_id)
    end

    def current
      by_season(Season.current_season_id)
    end

    def previous_season
      by_season(Season.previous_season_id)
    end

    def last_confirmed
      confirmed.order("season_id desc").limit(1).first
    end

    def last_enrollment
      where("season_id < ?", Season.current_season_id).order("season_id desc").limit(1)
    end

    def by_season id
      where(season_id: id)
    end

    def current_confirmed_report_required
      StudentRegistration.includes(:student).current.confirmed.report_card_required
    end

    def current_confirmed
      current.confirmed
    end

    def current_pending
      current.pending
    end

    def current_wait_listed
      current.wait_listed
    end

    def current_withdrawn
      current.withdrawn
    end

    def confirmed_students_count
      current_confirmed.count
    end

    def current_count
      current.count
    end

    def current_blocked_on_report_card
      current.blocked_on_report_card
    end

    def inactive
      where.not(id: current)
    end

    def status_options
      statuses.hash
    end

    def size_options
      sizes.hash
    end

    def unpaid
      pending
    end

    def paid
      confirmed_paid
    end

    def fee_waived
      confirmed_fee_waived
    end

    def confirmed
      confirmed_paid.or(confirmed_fee_waived)
    end

    def wait_listed
      wait_list
    end

    def current_wait_listed_count
      current_wait_listed.count
    end

    def wait_listed_count
      wait_listed.count
    end

    def with_valid_report_card
      where(report_card_submitted: true)
    end

    def ineligible
      where(report_card_submitted: false)
    end

    def order_by_student_last_name
      select(:first_name, :last_name, :student_id, :size_cd).joins(:student).order("students.last_name asc, students.first_name asc")
    end

    def in_aep_count
      in_aep.count
    end
  end

#----------- End Eigen Class ------------------#


  def ytd_attendance
    AttendanceSheet.current.map do |sheet|
      {id: sheet.id, date: sheet.session_date}.merge(sheet.status_for(id))
    end
  end

  def paid?
    !payment_id.nil?
  end

  def enrolled_in_aep?
    aep_registration.present? 
  end

  def season_description
    season.description
  end

  def parent_name
    parent.name
  end

  def unconfirmed?
    not confirmed?
  end

  def confirmed?
    [:confirmed_paid, :confirmed_fee_waived].include? status
  end

  def mark_as_paid(payment)
    self.payment = payment
    self.status = :confirmed_paid 
    save
  end

  def description
    "Fencing #{student_name} - #{season.slug}"
  end

  def attendance_count
    attendances.any? ? attendances.count : 0;
  end

  def fee
    season.fencing_fee
  end

  def is_missing_first_report_card?
    !current_report_cards.first_session_transcript_provided?
  end

  def is_missing_second_report_card?
    !current_report_cards.second_session_transcript_provided?
  end

  def requires_last_years_report_card?
    tracker = StudentReportCardTracker.new(student, Season.previous.academic_year)
    student.enrolled_last_season? && tracker.has_not_uploaded_first_and_second_report_card_for_season?
  end

  def current_report_cards
    @curr_report_cards ||= StudentReportCardTracker.new(student, Season.current.academic_year)
  end



  private

  def determine_status
    self.status = :wait_list and return if season.wait_list?
    self.status = :blocked_on_report_card if requires_last_years_report_card? 
  end
end

