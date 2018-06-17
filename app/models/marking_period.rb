class MarkingPeriod < ApplicationRecord

  def self.periods
    @periods ||= self.order(:name).inject({}){|a,v| a[v.id]=v.name;a}
  end

  def self.name_for id
    periods[id]
  end
end
