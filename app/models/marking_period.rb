class MarkingPeriod < ActiveRecord::Base
  attr_accessible :name, :notes
 PERIODS = self.order(:name).inject({}){|a,v| a[v.id]=v.name;a}
	default_scope order('name ASC')
end
