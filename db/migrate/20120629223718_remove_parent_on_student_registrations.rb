class RemoveParentOnStudentRegistrations < ActiveRecord::Migration
  def up
    remove_column :student_registrations, :parent_id
  end

  def down
    add_column :student_registrations, :parent_id, :integer
  end
end
