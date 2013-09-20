class CreateGradeFormats < ActiveRecord::Migration
  def change
    create_table :grade_formats do |t|
      t.string :name
      t.string :grade_type
      t.string :strategy

      t.timestamps
    end
  end
end
