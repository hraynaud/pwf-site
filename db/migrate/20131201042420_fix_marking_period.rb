class FixMarkingPeriod < ActiveRecord::Migration
  def change
    rename_column :report_cards, :marking_period, :marking_period_id
  end
end
