class AddSeasonToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :season_id, :integer
  end
end
