class AddAttendedToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :attended, :boolean, :default => false

  end
end
