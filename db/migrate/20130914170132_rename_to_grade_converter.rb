class RenameToGradeConverter < ActiveRecord::Migration
  def up
    rename_table :letter_to_number_grade_converters, :grade_converters
  end

  def down
    rename_table :grade_converter, :letter_to_number_grade_converters
  end
end
