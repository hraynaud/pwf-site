class AddSeasonToAttendanceSheet < ActiveRecord::Migration
  def change
    add_column :attendance_sheets, :season_id, :integer
  end
end
