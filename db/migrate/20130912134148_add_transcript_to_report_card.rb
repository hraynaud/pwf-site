class AddTranscriptToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :transcript, :string
  end
end
