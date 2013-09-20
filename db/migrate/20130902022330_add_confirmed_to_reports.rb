class AddConfirmedToReports < ActiveRecord::Migration
  def change
    add_column :session_reports, :confirmed, :boolean
    add_column :monthly_reports, :confirmed, :boolean
    add_column :year_end_reports, :confirmed, :boolean
  end
end
