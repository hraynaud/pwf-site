FactoryBot.define do
  factory :student  do |f|
    f.sequence(:first_name) { |n| "foo_child#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.dob {"2000-09-18"}
    f.gender {"M"}
    f.ethnicity {"African American"}
    f.association :parent, :factory => :parent

    trait :with_previous_registration do
      after(:create) do |student|
        FactoryBot.create(:student_registration, :previous, :student => student)
      end
    end

    trait :with_previous_confirmed_registration do
      after(:create) do |student|
        FactoryBot.create(:student_registration, :previous, :confirmed, :student => student)
      end
    end

   trait :with_previous_wait_list_registration do
      after(:create) do |student|
        FactoryBot.create(:student_registration, :previous, :wait_list, :student => student)
      end
    end

    trait :with_currrent_registration do
      after(:create) do |student|
        FactoryBot.create(:student_registration, :student => student)
      end
    end

    trait :with_currrent_confirmed_registration do
      after(:create) do |student|
        FactoryBot.create(:student_registration, :confirmed, :student => student)
      end
    end
  end
end
