class Season < ActiveRecord::Base
  has_many :student_registrations
  has_many :students, :through => :student_registrations
  has_many :payments
  validates :fall_registration_open, :beg_date, :end_date, :presence => true

  as_enum :status, ["Open", "Wait List", "Closed"]

  def is_current?
    Time.now.between?(fall_registration_open, end_date)
  end

  def self.current
    today = Time.now
    where(:current => true).first || NullSeason.generate
  end

  def self.current_season_id
    current.id
  end

  def description
   (new_record? ? "#{Time.now.year}": "Fall #{beg_date.year}-Spring #{end_date.year}") + " Season Registration"
  end

  def open_enrollment_enabled
     open_enrollment_date < Date.today
  end
  
  alias :name :description
   

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


