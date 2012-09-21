class AddFieldsToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :marking_period_type_cd, :integer

    add_column :report_cards, :marking_period, :integer

  end
end
