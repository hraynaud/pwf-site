class AddAttendanceSheetRefStaffAttendanceSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :staff_attendance_sheets, :attendance_sheet_id,  :integer
  end
end
