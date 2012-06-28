class Demographics < ActiveRecord::Base
  belongs_to :parent

  attr_accessible :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd
  validates :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :presence => true, :on => :create


  DEGREE = %w(High\ School Associates Bachelors Masters Doctorate)
  as_enum :degree, DEGREE.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  INCOME = %w(0-24,999 25,000-49,999 50,000-74,999 75,000-99,999, 100,000-124,999, 125,000+ )
  as_enum :income, INCOME.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  as_enum :home_type, [:Own, :Rent, :Other]
end
