require Rails.root.join("spec/support/stripe.rb")

FactoryGirl.define do

  factory :parent  do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:first_name) { |n| "foo#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.password "foobar"
    f.password_confirmation { |u| u.password }

    factory :complete_parent do
      address1 "123 Main Street"
      city "Anywhere"
      state "New York"
      zip "11234"
      primary_phone "555-123-4567"

      after(:create) do |parent|
        FactoryGirl.create_list(:demographic, 1, :parent => parent)
      end

      factory :parent_with_current_student_registrations do
        ignore do
          student_count 2
        end

        after(:create) do |parent, evaluator|
          FactoryGirl.create_list(:student_with_registration, evaluator.student_count, :parent => parent)
        end
      end

      factory :parent_with_old_student_registrations do
        ignore do
          student_count 2
        end

        after(:create) do |parent, evaluator|
          FactoryGirl.create_list(:student_with_old_registration, evaluator.student_count, :parent => parent)
        end
      end
    end

    factory :parent_with_no_season_demographics do
      after(:create) do |parent, evaluator|
        FactoryGirl.create_list(:no_season_demographics, 1, :parent => parent)
      end
    end

    factory :parent_with_invalid_demographics do
      after(:create) do |parent, evaluator|
        FactoryGirl.create_list(:invalid_demographics, 1, :parent => parent)
      end
    end

  end

  factory :student  do |f|
    f.sequence(:first_name) { |n| "foo_child#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.dob "2000-09-18"
    f.gender "M"
    f.association :parent, :factory => :parent

    factory :student_with_old_registration do
      after(:create) do |student|
        FactoryGirl.create_list(:old_registration, 1, :student => student)
      end
    end

    factory :student_with_registration do
      after(:create) do |student|
        FactoryGirl.create_list(:student_registration, 1, :student => student)
      end
    end
  end


  factory :student_registration  do |f|
    f.association :student, :factory => :student
    f.school "Hard Knocks"
    f.grade 5
    f.size_cd 3
    season  {Season.current || FactoryGirl.create(:season)}
    status "Pending"

    factory :old_registration do
      season {Season.where(:status_cd =>"Closed").first || FactoryGirl.create(:prev_season)}
    end
  end

  factory :payment do
    amount 19.99
    association :parent,  factory: :parent_with_current_student_registrations

    factory :completed_payment do
      completed true
    end

    factory :online_payment do
      method Payment.online

      factory :stripe_payment do
        email "foo@example.com"
        first_name "foo"
        last_name "bar"
        pay_with "card"
        stripe_card_token StripeHelper::VALID_TOKEN


        factory :zero_amount_payment do
          amount 0
        end

        factory :stripe_payment_invalid_customer do
          email "foo@example.@"
        end
      end

      factory :paypal_payment do

      end
    end
  end

  factory :demographic do
    parent
    season  {Season.current || FactoryGirl.create(:season)}

    income_range_cd 2
    education_level_cd 1
    home_ownership_cd 1
    num_minors 1
    num_adults 2

    factory :no_season_demographics do
      season nil
    end

    factory :invalid_demographics do
      num_minors nil
    end
  end



  factory :season  do |f|
    fall_registration_open '2012-06-22'
    beg_date '2012-09-22'
    end_date '2013-06-06'
    fencing_fee 50.00
    aep_fee 25.00

    factory :prev_season do
      fall_registration_open '2011-06-22'
      beg_date '2011-09-22'
      end_date '2012-06-06'
      status "Closed"
    end
  end


end
