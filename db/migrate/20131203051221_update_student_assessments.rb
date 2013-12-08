class UpdateStudentAssessments < ActiveRecord::Migration
 
  def change
    remove_column :student_assessments, :pre_test_grade
    remove_column :student_assessments, :post_test_grade
    add_column :student_assessments, :pre_test_math_score, :float
    add_column :student_assessments, :pre_test_reading_score,:float
    add_column :student_assessments, :pre_test_writing_score, :float
    add_column :student_assessments, :post_test_math_score, :float
    add_column :student_assessments, :post_test_reading_score, :float
    add_column :student_assessments, :post_test_writing_score, :float
    add_column :student_assessments, :pre_test_overall_score, :float
    add_column :student_assessments, :post_test_overall_score, :float
  end


end
