class AddEnumToStudentRegistrations < ActiveRecord::Migration
  def change
    rename_column :student_registrations, :size, :size_cd
  end
end
