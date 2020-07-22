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

  before_save :determine_status

  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates_uniqueness_of :student, scope: :season, message: "This student is already registered"
  validates :student, :presence => true, :on => :save

  delegate :name, :first_name, :last_name, :dob, :gender, :ethnicity,  :to => :student,:prefix => true
  delegate :id, :name, :email, :first_name,  :to => :parent,:prefix => true
  delegate :term, to: :season

  scope :report_card_exempt, ->{where(report_card_exempt: true)}
  scope :report_card_required, ->{where("grade <= 12").where.not(id: report_card_exempt)}
  scope :with_aep, ->{joins(:aep_registration)}
  scope :with_aep_paid, ->{with_aep.merge(AepRegistration.confirmed)}
  scope :with_aep_unpaid, ->{with_aep.current.confirmed.merge(AepRegistration.unpaid)}
  scope :in_aep, ->{with_aep_paid.confirmed}
  scope :not_in_aep, -> { where.not(id: in_aep)}
  scope :in_training_program, -> { where(in_training_program: true)}
  scope :exclude_selected, ->(exclude_list) { where.not(id: exclude_list)}
  scope :hs_seniors, ->{confirmed.where("student_registrations.grade = 12")}

  class << self

    def sizes_table
      sizes.hash.invert
    end

    def missing_report_card_for period
      report_card_required.where.not(id: student_registration_ids_from_current_year_report_card_for_period(period))
    end

    def student_registration_ids_from_current_year_report_card_for_period period
      ReportCard.by_year_and_marking_period(Season.current.academic_year, period)
        .select("student_registration_id")
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

    def set_statuses regs, status
      regs.each{|r| r.status = status}
    end

    def set_pending_to_waitlist
      current_pending.each{|r|r.wait_list!}
    end

  end

#----------- End Eigen Class ------------------#

  def renew
    return if season.current? or student.student_registrations.current.exists?
    new_registration  = self.dup
    new_registration.season = Season.current
    new_registration.grade = grade+1
    new_registration.pending!
    new_registration.payment = nil
    new_registration.report_cards = []
    new_registration.report_card_submitted = false
    new_registration.first_report_card_received = false
    new_registration.first_report_card_received_date = nil
    new_registration.second_report_card_received = false
    new_registration.second_report_card_received_date = nil
    new_registration.save
  end

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
    return false if report_card_exempt?
    tracker = StudentReportCardTracker.new(student, Season.previous.academic_year)
    student.enrolled_last_season? && tracker.has_not_uploaded_first_and_second_report_card_for_season?
  end

  def current_report_cards
    @curr_report_cards ||= StudentReportCardTracker.new(student, Season.current.academic_year)
  end

  def age
    season_start = season.beg_date
    season_start.year - student_dob.year - ((season_start.month > student_dob.month || (season_start.month == student_dob.month && season_start.day >= student_dob.day)) ? 0 : 1)
  end

  private

  def determine_status
    new_status = status

    self.status = case 
                  when season.wait_list?
                    :wait_list
                  when requires_last_years_report_card?
                    :blocked_on_report_card
                  else
                    new_status
                  end
  end
end

