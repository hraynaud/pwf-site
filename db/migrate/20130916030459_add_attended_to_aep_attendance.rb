class AddAttendedToAepAttendance < ActiveRecord::Migration
  def change
    add_column :aep_attendances, :attended, :boolean
  end
end
