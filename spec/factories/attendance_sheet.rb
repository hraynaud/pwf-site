FactoryBot.define do
  factory :attendance_sheet do |f|
    association :season
    f.sequence(:session_date){|n| Date.today + n*7}
  end
end
