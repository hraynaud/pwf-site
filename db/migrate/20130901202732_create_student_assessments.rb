class CreateStudentAssessments < ActiveRecord::Migration
  def change
    create_table :student_assessments do |t|
      t.integer :aep_registration_id
      t.string :pre_test_grade
      t.date :pre_test_date
      t.string :post_test_grade
      t.date :post_test_date

      t.timestamps
    end
  end
end
