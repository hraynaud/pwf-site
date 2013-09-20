class CreateAepRegistrations < ActiveRecord::Migration
  def change
    create_table :aep_registrations do |t|
      t.integer :student_registration_id
      t.integer :payment_id

      t.timestamps
    end
  end
end
