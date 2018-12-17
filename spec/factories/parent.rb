FactoryBot.define do
  factory :parent,  parent: :user , class: 'Parent' do

    trait :with_student do
      transient do
        count { 1 }
      end

      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:student, evaluator.count, :parent => parent)
      end
    end

    trait :with_current_demographic do
      after(:build) do |p|
        p.demographics << FactoryBot.create_list(:demographic, 1)
      end
    end

    trait :with_contact_detail do
      after(:build) do |p|
        FactoryBot.create(:contact_detail, user: p )
      end
    end

    trait :valid do
      with_current_demographic
      with_contact_detail
    end

    factory :parent_with_old_student_registrations do
      transient do
        student_count { 2 }
      end

      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:student, evaluator.student_count, :with_previous_registration, :parent => parent)
      end
    end

    factory :parent_with_current_student_registrations do
      transient do
        student_count { 2 }
      end

      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:student,  evaluator.student_count, :with_currrent_registration, :parent => parent)
      end
    end

    factory :parent_with_no_season_demographics do
      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:no_season_demographics, 1, :parent => parent)
      end
    end

    factory :parent_with_invalid_demographics do
      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:invalid_demographics, 1, :parent => parent)
      end
    end
  end
end
