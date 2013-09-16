class AddEnrollmentCountToAttendanceSheet < ActiveRecord::Migration
  def change
    add_column :attendance_sheets, :enrollment_count, :integer
  end
end
