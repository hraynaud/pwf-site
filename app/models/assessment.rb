class Assessment < ActiveRecord::Base
  attr_accessible :level, :math_questions, :reading_questions, :writing_questions, :evaluation, :season_id
  belongs_to :season
  delegate :term, to: :season

  before_create :set_season

  private

  def set_season
     self.season = Season.current
  end

end
