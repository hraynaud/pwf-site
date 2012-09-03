class CreateAttendanceSheets < ActiveRecord::Migration
  def change
    create_table :attendance_sheets do |t|
      t.date :session_date

      t.timestamps
    end
  end
end
