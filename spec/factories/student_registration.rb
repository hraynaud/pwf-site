FactoryBot.define do
  factory :student_registration  do |f|
    association :student, :factory => :student
    school "Hard Knocks"
    grade 5
    size_cd 2
    season  {Season.current }

    trait :confirmed do
      status_cd 2
    end

    trait :previous do
      season {Season.previous }
    end

    trait :with_aep do
     after(:create) do |reg|
       FactoryBot.create_list(:aep_registration, 1, :complete, :paid, :student_registration => reg)
      end
    end

    trait :invalid do
      grade nil
    end
  end
end
