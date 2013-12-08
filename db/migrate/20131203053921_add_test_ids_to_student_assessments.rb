class AddTestIdsToStudentAssessments < ActiveRecord::Migration
  def change
    add_column :student_assessments, :math_pre_test_id, :integer
    add_column :student_assessments, :reading_pre_test_id, :integer
    add_column :student_assessments, :writing_pre_test_id, :integer
    add_column :student_assessments, :math_post_test_id, :integer
    add_column :student_assessments, :reading_post_test_id, :integer
    add_column :student_assessments, :writing_post_test_id, :integer
  end
end
