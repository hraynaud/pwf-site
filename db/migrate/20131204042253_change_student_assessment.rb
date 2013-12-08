class ChangeStudentAssessment < ActiveRecord::Migration
  def change
    remove_column :student_assessments, :reading_pre_test_id
    remove_column :student_assessments, :writing_pre_test_id
    remove_column :student_assessments, :math_post_test_id
    remove_column :student_assessments, :reading_post_test_id
    rename_column :student_assessments, :math_pre_test_id, :pre_test_id
    rename_column :student_assessments, :writing_post_test_id, :post_test_id
  end
end
