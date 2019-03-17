class CreateStaffAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :staff_attendances do |t|
      t.references :staff, foreign_key: true
      t.references :staff_attendance_sheet, foreign_key: true

      t.timestamps
    end
  end
end
