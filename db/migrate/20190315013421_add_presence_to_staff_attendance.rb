class AddPresenceToStaffAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :staff_attendances, :attended, :boolean
  end
end
