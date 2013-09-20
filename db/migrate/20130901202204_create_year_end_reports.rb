class CreateYearEndReports < ActiveRecord::Migration
  def change
    create_table :year_end_reports do |t|
      t.integer :tutor_id
      t.integer :aep_registration_id
      t.string :attendance
      t.string :preparation
      t.string :participation
      t.string :academic_skills
      t.string :challenges_concerns
      t.string :achievements
      t.string :recommendations
      t.string :comments
      t.integer :status_cd

      t.timestamps
    end
  end
end
