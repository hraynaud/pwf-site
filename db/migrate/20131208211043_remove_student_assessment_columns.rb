class RemoveStudentAssessmentColumns < ActiveRecord::Migration
  def change
   remove_column :student_assessments, :pre_test_date
   remove_column :student_assessments, :post_test_date
   remove_column :student_assessments, :pre_test_overall_score
   remove_column :student_assessments, :post_test_overall_score
  end
end
