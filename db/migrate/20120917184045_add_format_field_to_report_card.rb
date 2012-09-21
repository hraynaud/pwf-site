class AddFormatFieldToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :format_cd, :integer

  end
end
