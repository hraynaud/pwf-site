class CreateCoParentships < ActiveRecord::Migration[5.2]
  def change
    create_table :co_parentships do |t|
      t.integer :co_parent_id
      t.integer :student_id

      t.timestamps
    end
  end
end
