class CreateStudentRegistrations < ActiveRecord::Migration
  def change
    create_table :student_registrations do |t|
      t.integer :student_id
      t.integer :season_id
      t.string :school
      t.integer :grade
      t.string :size
      t.text :medical_notes
      t.text :academic_notes
      t.boolean :academic_assistance

      t.timestamps
    end
  end
end
