class MarkingPeriod < ApplicationRecord
  FIRST_SESSION = "Fall/Winter"
  SECOND_SESSION = "Spring/Summer"
  has_many :report_cards

  scope :by_session_name, ->(name){where(name: name).first}

  def self.periods
    @periods ||= self.order(:name).inject({}){|a,v| a[v.id]=v.name;a}
  end

  def self.simple_periods
     where(name: [FIRST_SESSION, SECOND_SESSION])
  end

  def self.first_session
    where(name: FIRST_SESSION)
  end

  def self.second_session
    where(name: SECOND_SESSION)
  end

  def self.first_session_id
    first_session.first.id
  end

  def self.second_session_id
   second_session.first.id
  end

  def self.name_for id
    periods[id]
  end
end
