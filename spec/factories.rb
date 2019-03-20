require Rails.root.join("spec/support/stripe.rb")

FactoryBot.define do
  factory :season_staff do
    staff { nil }
    season { nil }
  end

  factory :staff_attendance do
    staff { nil }
    staff_attendance_sheet { nil }
  end

  factory :staff_attendance_sheet do
    session_date { "2019-03-14" }
  end

  factory :staff do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    phone_number { "MyString" }
    role { "MyString" }
  end

  factory :letter_to_number_grade_converter do
    letter { "A" }
    scale { "A-F" }
    min { 90 }
    max { 100 }
  end
end
