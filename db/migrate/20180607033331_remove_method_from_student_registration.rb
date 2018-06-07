class RemoveMethodFromStudentRegistration < ActiveRecord::Migration[5.2]
  def change
    remove_column :student_registrations,  :method
  end
end
