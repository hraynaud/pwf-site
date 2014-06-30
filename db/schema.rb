# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140630024446) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "aep_attendances", :force => true do |t|
    t.integer  "aep_registration_id"
    t.integer  "aep_session_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "attended"
  end

  create_table "aep_registrations", :force => true do |t|
    t.integer  "student_registration_id"
    t.integer  "payment_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "learning_disability"
    t.boolean  "iep"
    t.boolean  "student_academic_contract"
    t.boolean  "parent_participation_agreement"
    t.boolean  "transcript_test_score_release"
    t.string   "learning_disability_details"
    t.string   "iep_details"
    t.integer  "season_id"
    t.integer  "payment_status_cd",              :default => 0
  end

  create_table "aep_sessions", :force => true do |t|
    t.date     "session_date"
    t.string   "notes"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "season_id"
    t.integer  "enrollment_count"
  end

  create_table "assessments", :force => true do |t|
    t.string   "level"
    t.integer  "math_questions"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "season_id"
    t.string   "evaluation"
    t.integer  "reading_questions"
    t.integer  "writing_questions"
  end

  create_table "attendance_sheets", :force => true do |t|
    t.date     "session_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "season_id"
    t.integer  "enrollment_count"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "student_registration_id"
    t.integer  "attendance_sheet_id"
    t.date     "session_date"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "attended",                :default => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "demographics", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "num_adults"
    t.integer  "num_minors"
    t.integer  "income_range_cd"
    t.integer  "education_level_cd"
    t.integer  "home_ownership_cd"
    t.integer  "season_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "ethnicities", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "grade_converters", :force => true do |t|
    t.float    "min"
    t.float    "max"
    t.float    "custom"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "grade_format_id"
    t.string   "letter"
  end

  create_table "grade_formats", :force => true do |t|
    t.string   "name"
    t.string   "grade_type"
    t.string   "strategy"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "grades", :force => true do |t|
    t.integer  "student_registration_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "report_card_id"
    t.string   "value"
    t.integer  "subject_id"
    t.float    "hundred_point"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "instructor_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "instructors", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "managers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "marking_periods", :force => true do |t|
    t.string   "name"
    t.string   "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "strategy"
  end

  create_table "monthly_reports", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "aep_registration_id"
    t.integer  "month"
    t.integer  "year"
    t.integer  "num_hours_with_student"
    t.integer  "num_preparation_hours"
    t.string   "student_goals"
    t.boolean  "goals_achieved"
    t.string   "progress_notes"
    t.boolean  "new_goals_set"
    t.string   "new_goals_desc"
    t.string   "issues_concerns"
    t.string   "issues_resolution"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "confirmed"
    t.string   "mgr_comment"
    t.integer  "tutoring_assignment_id"
  end

  create_table "parents", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "avatar"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "amount",           :precision => 8, :scale => 2, :default => 1.0
    t.string   "payment_method"
    t.string   "token"
    t.string   "identifier"
    t.string   "payer_id"
    t.boolean  "recurring",                                      :default => false
    t.boolean  "digital",                                        :default => false
    t.boolean  "popup",                                          :default => false
    t.boolean  "completed",                                      :default => false
    t.boolean  "canceled",                                       :default => false
    t.integer  "parent_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.string   "stripe_charge_id"
    t.integer  "method_cd"
    t.integer  "check_no"
    t.integer  "season_id"
    t.integer  "program_cd"
  end

  create_table "report_cards", :force => true do |t|
    t.integer  "student_registration_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "marking_period_type_cd"
    t.integer  "marking_period"
    t.integer  "format_cd"
    t.string   "transcript"
    t.integer  "season_id"
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.string   "sql"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seasons", :force => true do |t|
    t.date     "beg_date"
    t.date     "end_date"
    t.date     "fall_registration_open"
    t.date     "spring_registration_open"
    t.integer  "status_cd"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.boolean  "current"
    t.decimal  "fencing_fee",              :precision => 8, :scale => 2
    t.decimal  "aep_fee",                  :precision => 8, :scale => 2
    t.date     "open_enrollment_date"
    t.string   "message"
  end

  create_table "session_reports", :force => true do |t|
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
    t.text     "comments"
    t.boolean  "confirmed"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.text     "mgr_comment"
    t.integer  "tutoring_assignment_id"
  end

  create_table "student_assessments", :force => true do |t|
    t.integer  "aep_registration_id"
    t.string   "pre_test_grade"
    t.date     "pre_test_date"
    t.string   "post_test_grade"
    t.date     "post_test_date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "student_registrations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "season_id"
    t.string   "school"
    t.integer  "grade"
    t.integer  "size_cd"
    t.text     "medical_notes"
    t.text     "academic_notes"
    t.boolean  "academic_assistance"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "status_cd",             :default => 0
    t.integer  "payment_id"
    t.integer  "group_id"
    t.boolean  "report_card_submitted", :default => false
  end

  create_table "students", :force => true do |t|
    t.integer  "parent_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.string   "gender"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.boolean  "ethn_hispanic_latino"
    t.boolean  "ethn_black_african_american"
    t.boolean  "ethn_native_american"
    t.boolean  "ethn_asian"
    t.boolean  "ethn_pacific_islander"
    t.boolean  "ethn_caucasian"
    t.string   "ethn_other"
    t.string   "avatar"
    t.string   "ethnicity"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tutoring_assignments", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "student_registration_id"
    t.integer  "subject_id"
    t.string   "notes"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "aep_registration_id"
  end

  create_table "tutors", :force => true do |t|
    t.string   "occupation"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_primary_phone"
    t.string   "emergency_contact_secondary_phone"
    t.string   "emergency_contact_relationship"
    t.boolean  "returning"
    t.integer  "season_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "other_phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "is_mgr"
    t.boolean  "is_parent"
    t.boolean  "is_tutor"
    t.integer  "profileable_id"
    t.string   "profileable_type"
    t.boolean  "is_instructor"
  end

  add_index "users", ["email"], :name => "index_parents_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_parents_on_reset_password_token", :unique => true

  create_table "workshop_enrollments", :force => true do |t|
    t.integer  "workshop_id"
    t.integer  "aep_registration_id"
    t.integer  "status_cd"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "workshop_enrollments", ["aep_registration_id"], :name => "index_workshop_enrollments_on_aep_registration_id"
  add_index "workshop_enrollments", ["workshop_id"], :name => "index_workshop_enrollments_on_workshop_id"

  create_table "workshops", :force => true do |t|
    t.string   "name"
    t.integer  "tutor_id"
    t.string   "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "season_id"
  end

  create_table "year_end_reports", :force => true do |t|
    t.integer  "tutor_id"
    t.integer  "aep_registration_id"
    t.string   "attendance"
    t.string   "preparation"
    t.string   "participation"
    t.string   "academic_skills"
    t.string   "challenges_concerns"
    t.string   "achievements"
    t.string   "recommendations"
    t.string   "comments"
    t.integer  "status_cd"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "confirmed"
    t.string   "mgr_comment"
    t.integer  "tutoring_assignment_id"
  end

end
