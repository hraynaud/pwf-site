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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_06_25_035030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "namespace", limit: 255
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "aep_attendances", id: :serial, force: :cascade do |t|
    t.integer "aep_registration_id"
    t.integer "aep_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attended"
  end

  create_table "aep_registrations", id: :serial, force: :cascade do |t|
    t.integer "student_registration_id"
    t.integer "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "learning_disability"
    t.boolean "iep"
    t.boolean "student_academic_contract"
    t.boolean "parent_participation_agreement"
    t.boolean "transcript_test_score_release"
    t.string "learning_disability_details", limit: 255
    t.string "iep_details", limit: 255
    t.integer "season_id"
    t.integer "payment_status_cd", default: 0
  end

  create_table "aep_sessions", id: :serial, force: :cascade do |t|
    t.date "session_date"
    t.string "notes", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.integer "enrollment_count"
  end

  create_table "assessments", id: :serial, force: :cascade do |t|
    t.string "level", limit: 255
    t.integer "math_questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.string "evaluation", limit: 255
    t.integer "reading_questions"
    t.integer "writing_questions"
  end

  create_table "attendance_sheets", id: :serial, force: :cascade do |t|
    t.date "session_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.integer "enrollment_count"
  end

  create_table "attendances", id: :serial, force: :cascade do |t|
    t.integer "student_registration_id"
    t.integer "attendance_sheet_id"
    t.date "session_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attended", default: false
  end

  create_table "contact_details", force: :cascade do |t|
    t.bigint "user_id"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "primary_phone"
    t.string "secondary_phone"
    t.string "other_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contact_details_on_user_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "demographics", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "num_adults"
    t.integer "num_minors"
    t.integer "income_range_cd"
    t.integer "education_level_cd"
    t.integer "home_ownership_cd"
    t.integer "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ethnicities", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grade_converters", id: :serial, force: :cascade do |t|
    t.float "min"
    t.float "max"
    t.float "custom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grade_format_id"
    t.string "letter", limit: 255
  end

  create_table "grade_formats", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "grade_type", limit: 255
    t.string "strategy", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grades", id: :serial, force: :cascade do |t|
    t.integer "student_registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "report_card_id"
    t.string "value", limit: 255
    t.integer "subject_id"
    t.float "hundred_point"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "instructor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructors", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "managers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marking_periods", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "notes", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "strategy", limit: 255
  end

  create_table "monthly_reports", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "aep_registration_id"
    t.integer "month"
    t.integer "year"
    t.integer "num_hours_with_student"
    t.integer "num_preparation_hours"
    t.string "student_goals", limit: 255
    t.boolean "goals_achieved"
    t.string "progress_notes", limit: 255
    t.boolean "new_goals_set"
    t.string "new_goals_desc", limit: 255
    t.string "issues_concerns", limit: 255
    t.string "issues_resolution", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed"
    t.string "mgr_comment", limit: 255
    t.integer "tutoring_assignment_id"
  end

  create_table "parents", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "avatar", limit: 255
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "1.0"
    t.string "payment_method", limit: 255
    t.string "token", limit: 255
    t.string "identifier", limit: 255
    t.string "payer_id", limit: 255
    t.boolean "recurring", default: false
    t.boolean "digital", default: false
    t.boolean "popup", default: false
    t.boolean "completed", default: false
    t.boolean "canceled", default: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_charge_id", limit: 255
    t.integer "payment_medium_cd"
    t.integer "check_no"
    t.integer "season_id"
    t.integer "program_cd"
    t.integer "parent_id_bkp"
  end

  create_table "report_cards", id: :serial, force: :cascade do |t|
    t.integer "student_registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "marking_period_type_cd"
    t.integer "marking_period"
    t.integer "format_cd"
    t.string "transcript", limit: 255
    t.integer "season_id"
    t.string "academic_year", limit: 255
    t.integer "student_id"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "sql", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.date "beg_date"
    t.date "end_date"
    t.date "fall_registration_open"
    t.date "spring_registration_open"
    t.integer "status_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "current"
    t.decimal "fencing_fee", precision: 8, scale: 2
    t.decimal "aep_fee", precision: 8, scale: 2
    t.date "open_enrollment_date"
    t.string "message", limit: 255
  end

  create_table "session_reports", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "aep_registration_id"
    t.integer "student_registration_id"
    t.date "session_date"
    t.integer "worked_on_cd"
    t.string "worked_on_other", limit: 255
    t.integer "preparation_cd"
    t.integer "participation_cd"
    t.integer "comprehension_cd"
    t.integer "motivation_cd"
    t.text "comments"
    t.boolean "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "mgr_comment"
    t.integer "tutoring_assignment_id"
  end

  create_table "student_assessments", id: :serial, force: :cascade do |t|
    t.integer "aep_registration_id"
    t.string "pre_test_grade", limit: 255
    t.date "pre_test_date"
    t.string "post_test_grade", limit: 255
    t.date "post_test_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_registrations", id: :serial, force: :cascade do |t|
    t.integer "student_id"
    t.integer "season_id"
    t.string "school", limit: 255
    t.integer "grade"
    t.integer "size_cd"
    t.text "medical_notes"
    t.text "academic_notes"
    t.boolean "academic_assistance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_cd", default: 0
    t.integer "payment_id"
    t.integer "group_id"
    t.boolean "report_card_submitted", default: false
    t.boolean "first_report_card_received"
    t.date "first_report_card_received_date"
    t.boolean "second_report_card_received"
    t.date "second_report_card_received_date"
    t.date "first_report_card_expected_date"
    t.date "second_report_card_expected_date"
    t.boolean "report_card_exempt"
  end

  create_table "students", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.date "dob"
    t.string "gender", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ethn_hispanic_latino"
    t.boolean "ethn_black_african_american"
    t.boolean "ethn_native_american"
    t.boolean "ethn_asian"
    t.boolean "ethn_pacific_islander"
    t.boolean "ethn_caucasian"
    t.string "ethn_other", limit: 255
    t.string "avatar", limit: 255
    t.string "ethnicity", limit: 255
    t.integer "parent_id_bkp"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutoring_assignments", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "student_registration_id"
    t.integer "subject_id"
    t.string "notes", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "aep_registration_id"
  end

  create_table "tutors", id: :serial, force: :cascade do |t|
    t.string "occupation", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "emergency_contact_name", limit: 255
    t.string "emergency_contact_primary_phone", limit: 255
    t.string "emergency_contact_secondary_phone", limit: 255
    t.string "emergency_contact_relationship", limit: 255
    t.boolean "returning"
    t.integer "season_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "encrypted_password", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "primary_phone", limit: 255
    t.string "secondary_phone", limit: 255
    t.string "other_phone", limit: 255
    t.string "address1", limit: 255
    t.string "address2", limit: 255
    t.string "city", limit: 255
    t.string "state", limit: 255
    t.string "zip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean "is_mgr"
    t.boolean "is_parent"
    t.boolean "is_tutor"
    t.integer "profileable_id"
    t.string "profileable_type", limit: 255
    t.boolean "is_instructor"
    t.string "type"
    t.index ["email"], name: "index_parents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true
  end

  create_table "workshop_enrollments", id: :serial, force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "aep_registration_id"
    t.integer "status_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aep_registration_id"], name: "index_workshop_enrollments_on_aep_registration_id"
    t.index ["workshop_id"], name: "index_workshop_enrollments_on_workshop_id"
  end

  create_table "workshops", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "tutor_id"
    t.string "notes", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
  end

  create_table "year_end_reports", id: :serial, force: :cascade do |t|
    t.integer "tutor_id"
    t.integer "aep_registration_id"
    t.string "attendance", limit: 255
    t.string "preparation", limit: 255
    t.string "participation", limit: 255
    t.string "academic_skills", limit: 255
    t.string "challenges_concerns", limit: 255
    t.string "achievements", limit: 255
    t.string "recommendations", limit: 255
    t.string "comments", limit: 255
    t.integer "status_cd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed"
    t.string "mgr_comment", limit: 255
    t.integer "tutoring_assignment_id"
  end

  add_foreign_key "contact_details", "users"
end
