class CreateMonthlyReports < ActiveRecord::Migration
  def change
    create_table :monthly_reports do |t|
      t.integer :tutor_id
      t.integer :aep_registration_id
      t.integer :month
      t.integer :year
      t.integer :num_hours_with_student
      t.integer :num_preparation_hours
      t.string :student_goals
      t.boolean :goals_achieved
      t.string :progress_notes
      t.boolean :new_goals_set
      t.string :new_goals_desc
      t.string :issues_concerns
      t.string :issues_resolution

      t.timestamps
    end
  end
end
