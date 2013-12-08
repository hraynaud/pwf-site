class AddEvaluationToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :evaluation, :string
  end
end
