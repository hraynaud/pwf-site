class MarkingPeriod < ApplicationRecord
  FIRST_SESSION = "Fall/Winter"
  SECOND_SESSION = "Spring/Summer"

  has_many :report_cards

  scope :by_session_name, ->(name){where(name: name).first}

  def self.periods
    @periods ||= self.order(:name).inject({}){|a,v| a[v.id]=v.name;a}
  end

  def self.fall_winter
    FIRST_SESSION
  end

  def self.spring_summer
     SECOND_SESSION
  end

  def self.simple_periods
    where(name: [FIRST_SESSION, SECOND_SESSION])
  end

  def self.first_session_id
    by_session_name(FIRST_SESSION).id
  end

  def self.second_session_id
    by_session_name(SECOND_SESSION).id
  end

  def self.name_for id
    periods[id]
  end

end
