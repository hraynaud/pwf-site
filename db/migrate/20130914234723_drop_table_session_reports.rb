class DropTableSessionReports < ActiveRecord::Migration
  def up
    drop_table :session_reports
  end

  def down
  end
end
