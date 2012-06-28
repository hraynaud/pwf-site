class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :parent_id
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.string :gender

      t.timestamps
    end
  end
end
