class AddParentIdToStudentRegistration < ActiveRecord::Migration
  def change
    add_column :student_registrations, :parent_id, :integer

  end
end
