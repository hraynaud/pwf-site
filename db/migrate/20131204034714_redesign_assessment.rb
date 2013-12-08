class RedesignAssessment < ActiveRecord::Migration
  def change 
    remove_column :assessments, :subject
    rename_column :assessments, :questions, :math_questions
    add_column :assessments,  :reading_questions, :integer
    add_column :assessments, :writing_questions, :integer
  end

end
