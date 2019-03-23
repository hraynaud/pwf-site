class AddAttendanceSheetIdToStaffAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :staff_attendances, :attendance_sheet_id, :integer
  end
end
