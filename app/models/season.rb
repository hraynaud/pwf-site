class Season < ApplicationRecord
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  has_many :payments
  has_many :attendance_sheets
  validates :fall_registration_open, :beg_date, :presence => true
  validates :enrollment_limit, :presence => true, if: ->{current}
  has_many :season_staffs
  has_many :staffs, through: :season_staffs

  #TODO figure out if Pre-Open status can be safely removed
  STATUS_VALUES=["Pre-Open", "Open", "Wait List", "Closed"]
  as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  scope :by_season, ->{order("id desc")}
  scope :current_active, ->{where(current:true)}
  accepts_nested_attributes_for :season_staffs

  def min_attendance_count_for_hoodies
    (num_sessions*min_hoodies_attendance_pct).round
  end

  def min_attendance_count_for_t_shirts
    (num_sessions*min_t_shirt_attendance_pct).round
  end

  def num_sessions
    attendance_sheets.size
  end

  def min_hoodies_attendance_pct
    to_pct(min_for_hoodie)
  end

  def min_t_shirt_attendance_pct
    to_pct(min_for_t_shirt)
  end

  def to_pct val
    val*0.01
  end

  def staff_ids
    season_staffs.map(&:staff_id)
  end

  def staff_ids= ids
    SeasonStaffManager.new(self).update ids
  end

  def handle_staff_changes
    @staff_mgr.update
  end

  def self.current
    where(:current => true).last || NullSeason.generate
  end

  def self.previous
    where("id < ?", Season.current.id).max
  end

  def self.next
    where("beg_date > ? and id > ?", current.end_date, current.id).first
  end

  def self.previous_season_id
    previous.id
  end

  def self.current_season_id
    current.id
  end

  def self.first_and_last
    Season.order(created_at: :desc).limit(2)
  end

  def open_enrollment_period_is_active?
    !closed? && current && open_enrollment_has_started?
  end

  def enrollment_limit_reached?
    StudentRegistration.confirmed_students_count >= enrollment_limit
  end

  def should_waitlist_new_registrations?
    #TODO should check against enrollment_limit_reached? method
    current && confirmed_students_count > enrollment_limit
  end

  def wait_list_enrollment_period_is_active?
    current &&  Date.today >= waitlist_registration_date
  end

  def pre_enrollment_enabled?
    returning_students_registration_date.nil? ? false : Date.today >= returning_students_registration_date
  end

  def confirmed_students
    students.merge(StudentRegistration.current.confirmed)
  end

  def confirmed_students_count
    confirmed_students.count
  end

  def description
    term + " Season"
  end

  def term
    (new_record? ? "#{Time.now.year}": "Fall #{beg_date.year}-Spring #{end_date.year}")
  end

  def has_space_for_more_students?
    confirmed_students_count < enrollment_limit
  end

  def academic_year
    term
  end

  def slug
    "#{beg_date.year}-#{end_date.year}"
  end

  def fee_for prog
    prog == :aep ? aep_fee : fencing_fee
  end

  def num_sessions_as_of d=Date.today
    attendance_sheets.where("session_date <= ?", d).size
  end 

  def attendees_history
    attendance_sheets
      .joins(:student_attendances)
      .select("attendance_sheets.session_date")
      .where("attendances.attended is true")
      .group(["attendance_sheets.session_date"])
      .order("attendance_sheets.session_date")
      .count("attendances.attended")
  end


  def absentees_history
    attendance_sheets
      .joins(:student_attendances)
      .select("attendance_sheets.session_date")
      .where("attendances.attended is false")
      .group(["attendance_sheets.session_date"])
      .order("attendance_sheets.session_date")
      .count("attendances.attended")
  end

  alias :name :description
 
  def returning_students_registration_date 
    fall_registration_open
  end

  private

  def open_enrollment_has_started?
    open_enrollment_date.present? && open_enrollment_date <= Date.today
  end

  class NullSeason 
    def self.generate
      @season = Season.new(
        :fall_registration_open => 1.year.from_now, 
        :spring_registration_open => 1.year.from_now, 
        :beg_date => 1.year.from_now, 
        :end_date => 1.year.from_now,:current=> false,
        :status_cd => 2
      )
    end
  end

end


