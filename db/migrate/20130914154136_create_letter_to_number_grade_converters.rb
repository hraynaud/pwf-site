class CreateLetterToNumberGradeConverters < ActiveRecord::Migration
  def change
    create_table :letter_to_number_grade_converters do |t|
      t.string :letter
      t.string :scale
      t.string :strategy
      t.float :min
      t.float :max
      t.float :custom

      t.timestamps
    end
  end
end
