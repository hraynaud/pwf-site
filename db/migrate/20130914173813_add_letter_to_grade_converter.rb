class AddLetterToGradeConverter < ActiveRecord::Migration
  def change
    add_column :grade_converters, :letter, :string
  end
end
