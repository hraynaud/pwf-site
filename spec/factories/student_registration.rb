FactoryBot.define do
  factory :student_registration  do |f|
    association :student, :factory => :student
    school "Hard Knocks"
    grade 5
    size_cd 2
    season  {Season.current }

    factory :paid_registration do
      school "Paid Dues"
      after(:create) do |reg|
        reg.confirmed_paid!
        reg.save
      end
    end

    trait :previous do
      season {Season.previous }
    end
  end
end
