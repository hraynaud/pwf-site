class CreateWorkshopEnrollments < ActiveRecord::Migration
  def change
    create_table :workshop_enrollments do |t|
      t.references :workshop
      t.references :aep_registration
      t.integer :status_cd

      t.timestamps
    end
    add_index :workshop_enrollments, :workshop_id
    add_index :workshop_enrollments, :aep_registration_id
  end
end
