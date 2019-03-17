class CreateStaffAttendanceSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :staff_attendance_sheets do |t|
      t.date :session_date

      t.timestamps
    end
  end
end
