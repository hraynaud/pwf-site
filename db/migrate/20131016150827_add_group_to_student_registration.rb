class AddGroupToStudentRegistration < ActiveRecord::Migration
  def change
    add_column :student_registrations, :group, :string
  end
end
