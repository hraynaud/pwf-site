class AddNormalizedAvgToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :normalized_avg, :float
  end
end
