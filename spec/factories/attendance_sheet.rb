FactoryBot.define do
  factory :attendance_sheet do
    association :season
    session_date Date.today
  end
end
