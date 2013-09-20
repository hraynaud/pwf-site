class RecreateSessionReport < ActiveRecord::Migration
  def change
    create_table "session_reports" do |t|
      t.integer  "tutor_id"
      t.integer  "aep_registration_id"
      t.integer  "student_registration_id"
      t.date     "session_date"
      t.integer  "worked_on_cd"
      t.string   "worked_on_other"
      t.integer  "preparation_cd"
      t.integer  "participation_cd"
      t.integer  "comprehension_cd"
      t.integer  "motivation_cd"
      t.string   "comments"
      t.boolean  "confirmed"
      t.timestamps
    end
  end
end
