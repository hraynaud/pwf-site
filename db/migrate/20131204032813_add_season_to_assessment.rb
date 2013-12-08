class AddSeasonToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :season_id, :integer
  end
end
