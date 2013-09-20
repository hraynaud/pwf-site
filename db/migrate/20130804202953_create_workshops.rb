class CreateWorkshops < ActiveRecord::Migration
  def change
    create_table :workshops do |t|
      t.string :name
      t.integer :tutor_id
      t.string :notes

      t.timestamps
    end
  end
end
