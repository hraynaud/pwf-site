class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :student_registration_id

      t.timestamps
    end
  end
end
