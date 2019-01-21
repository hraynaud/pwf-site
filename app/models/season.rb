class Season < ApplicationRecord
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  has_many :payments
  validates :fall_registration_open, :beg_date, :presence => true
  validates :enrollment_limit, :presence => true, if: ->{current}

 STATUS_VALUES=["Pre-Open", "Open", "Wait List", "Closed"]
 as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  scope :by_season, ->{order("id desc")}
  scope :current_active, ->{where(current:true)}

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
   !closed? && has_valid_open_enrollment_date? && current && confirmed_students_count < enrollment_limit
  end

  def enrollment_limit_reached?
    StudentRegistration.confirmed_students_count >= enrollment_limit
  end

  def wait_list_period_is_active?
    current && confirmed_students_count > enrollment_limit
  end

  def pre_enrollment_enabled?
    fall_registration_open.nil? ? false : fall_registration_open <= Date.today
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

  def academic_year
    term
  end

  def slug
    "#{beg_date.year}-#{end_date.year}"
  end

  def fee_for prog
    prog == :aep ? aep_fee : fencing_fee
  end

  alias :name :description

  private

  def has_valid_open_enrollment_date?
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


