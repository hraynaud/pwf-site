class CreateAepSessions < ActiveRecord::Migration
  def change
    create_table :aep_sessions do |t|
      t.date :session_date
      t.string :notes

      t.timestamps
    end
  end
end
