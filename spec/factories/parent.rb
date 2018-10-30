FactoryBot.define do
  factory :parent,  parent: :user , class: 'Parent' do

    trait :with_student do
      ignore do
        count { 1 }
      end

      after(:create) do |parent, evaluator|
        FactoryBot.create_list(:student, evaluator.count, :parent => parent)
      end
    end

    factory :parent_with_current_demographic_profile do
      after(:build) do |p|
        p.demographics << FactoryBot.create_list(:demographic, 1)
      end

      factory :parent_with_old_student_registrations do
        ignore do
          student_count { 2 }
        end

        after(:create) do |parent, evaluator|
          FactoryBot.create_list(:student, evaluator.student_count, :with_previous_registration, :parent => parent)
        end
      end
      factory :parent_with_current_student_registrations do
        ignore do
          student_count { 2 }
        end

        after(:create) do |parent, evaluator|
          FactoryBot.create_list(:student,  evaluator.student_count, :with_currrent_registration, :parent => parent)
        end
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
