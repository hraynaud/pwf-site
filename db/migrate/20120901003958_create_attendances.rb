class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :student_registration_id
      t.integer :attendance_sheet_id
      t.date :session_date
      t.timestamps
    end
  end
end
