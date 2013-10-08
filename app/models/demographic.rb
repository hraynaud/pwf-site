class Demographic < ActiveRecord::Base
  belongs_to :parent
  belongs_to :season

  attr_accessible :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season_id
  validates :num_adults, :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season, :presence => true


  DEGREE = %w(High\ School Associates Bachelors Masters Doctorate)
  as_enum :education_level, DEGREE.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  INCOME = %w(0-24,999 25,000-49,999 50,000-74,999 75,000-99,999, 100,000-124,999, 125,000+ )
  as_enum :income_range, INCOME.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  as_enum :home_ownership, [:Own, :Rent, :Other]
  before_validation :set_season


  scope :current, ->(){where(season_id: Season.current_season_id)}

  private
  def set_season
    if self.season.nil?
      self.season = Season.current
    end
  end
end
