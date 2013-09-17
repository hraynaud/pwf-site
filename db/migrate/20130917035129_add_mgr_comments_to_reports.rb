class AddMgrCommentsToReports < ActiveRecord::Migration
  def change
    add_column :session_reports, :mgr_comment, :string
    add_column :monthly_reports, :mgr_comment, :string
    add_column :year_end_reports, :mgr_comment, :string
  end
end
