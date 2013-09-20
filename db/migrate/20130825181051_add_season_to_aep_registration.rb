class AddSeasonToAepRegistration < ActiveRecord::Migration
  def change
    add_column :aep_registrations, :season_id, :integer
  end
end
