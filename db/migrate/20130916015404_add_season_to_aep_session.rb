class AddSeasonToAepSession < ActiveRecord::Migration
  def change
    add_column :aep_sessions, :season_id, :integer
  end
end
