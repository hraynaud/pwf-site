class AddTempTables < ActiveRecord::Migration
  def up

  create_table "temp_registrations", :force => true do |t|
    t.integer  "temp_student_id"
    t.integer  "season_id"
    t.integer  "grade"
    t.string   "school"
    t.string   "size_cd"
  end

  create_table "temp_students", :force => true do |t|
    t.integer  "temp_parent_id"
    t.integer  "pwf_parent_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "dob"
  end

    create_table "temp_parents", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "primary_phone"
  end






  end

  def down
  end
end
