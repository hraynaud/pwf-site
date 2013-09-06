class AddSeasonToWorkshop < ActiveRecord::Migration
  def change
    add_column :workshops, :season_id, :integer
  end
end
