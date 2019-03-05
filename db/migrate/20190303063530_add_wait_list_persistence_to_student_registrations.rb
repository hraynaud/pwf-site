class AddWaitListPersistenceToStudentRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :student_registrations, :keep_on_notify_if_waitlisted, :boolean
  end
end
