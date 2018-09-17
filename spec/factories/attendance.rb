FactoryBot.define do
  factory :attendance do
    association :attendance_sheet
    association :student_registration
    session_date Date.today
  end
end
