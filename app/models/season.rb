class Season < ApplicationRecord
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  has_many :payments
  validates :fall_registration_open, :beg_date, :end_date, :presence => true

 STATUS_VALUES=["Open", "Wait List", "Closed"]
 as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  scope :by_season, ->{order("id desc")}
  scope :current_active, ->{where(current:true)}

  def self.current
    where(:current => true).last || NullSeason.generate
  end

  def self.previous
    where("beg_date > ? and id != ?", previous_begin_date , current.id ).first
  end

  def self.previous_season_id
    previous.id
  end

  def self.current_season_id
    current.id
  end

  def self.previous_begin_date
    current.beg_date - 54.weeks
  end

  def is_current?
    Time.now.between?(fall_registration_open, end_date)
  end

  def open_enrollment_enabled
    open_enrollment_date.nil? ? false : open_enrollment_date <= Date.today
  end

  def pre_enrollment_enabled?
    fall_registration_open.nil? ? false : fall_registration_open <= Date.today
  end

  def confirmed_students
    students.merge(StudentRegistration.confirmed)
  end

  def description
    term + " Season"
  end

  def term
    (new_record? ? "#{Time.now.year}": "Fall #{beg_date.year}-Spring #{end_date.year}")
  end

  def slug
    "#{beg_date.year}- #{end_date.year}"
  end

  def fee_for prog
    prog == :aep ? aep_fee : fencing_fee
  end

  alias :name :description

  private


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


