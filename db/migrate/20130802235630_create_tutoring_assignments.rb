class CreateTutoringAssignments < ActiveRecord::Migration
  def change
    create_table :tutoring_assignments do |t|
      t.integer :tutor_id
      t.integer :student_registration_id
      t.integer :subject_id
      t.string :notes

      t.timestamps
    end
  end
end
