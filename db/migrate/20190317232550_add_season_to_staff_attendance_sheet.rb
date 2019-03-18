class AddSeasonToStaffAttendanceSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :staff_attendance_sheets, :season_id, :integer
    remove_column :staff_attendance_sheets, :attendance_sheet_id
  end
end
