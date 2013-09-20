class RemoveFieldsFromConverter < ActiveRecord::Migration
  def up
    remove_column :grade_converters, :letter
    remove_column :grade_converters, :scale
    remove_column :grade_converters, :strategy
  end

  def down
  end
end
