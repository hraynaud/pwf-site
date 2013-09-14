class AddGradeFormatIdToGradeConverter < ActiveRecord::Migration
  def change
    add_column :grade_converters, :grade_format_id, :integer
  end
end
