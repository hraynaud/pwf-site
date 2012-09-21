class AddSubjectToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :subject_id, :integer

  end
end
