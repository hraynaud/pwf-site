class AddHundredPointToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :hundred_point, :float
  end
end
