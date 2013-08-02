class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.integer :user_id
      t.string  :occupation
      t.timestamps
    end
  end
end
