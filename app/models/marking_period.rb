class MarkingPeriod < ApplicationRecord

  def self.periods
    @periods ||= self.order(:name).inject({}){|a,v| a[v.id]=v.name;a}
  end

  def self.simple_periods
     where(name: ["Fall/Winter", "Spring/Summer"])
  end

  def self.name_for id
    periods[id]
  end
end
