class AddColumnsToStudentRegistration < ActiveRecord::Migration
  def change
    add_column :student_registrations, :status_cd, :integer

  end
end
