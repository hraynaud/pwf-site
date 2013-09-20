class CreateAepAttendances < ActiveRecord::Migration
  def change
    create_table :aep_attendances do |t|
      t.references :aep_registration
      t.references :aep_session
      t.timestamps
    end
  end
end
