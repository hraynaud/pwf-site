require Rails.root.join("spec/support/stripe.rb")

FactoryGirl.define do

  factory :user  do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:first_name) { |n| "foo#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.password "foobar"
    f.password_confirmation { |u| u.password }
    address1 "123 Main Street"
    city "Anywhere"
    state "NY"
    zip "11234"
    primary_phone "555-123-4567"

    factory :manager_user do
      is_mgr true 
    end

    factory :tutor_user do
      sequence(:email) { |n| "tut_foo#{n}@example.com" }
      sequence(:first_name) { |n| "tutor_foo#{n}" }
      is_tutor true
    end

    factory :parent_user do
      is_parent true

      factory :invalid_parent_user do
        primary_phone nil
      end
    end
  end

  factory :demographic do
    season
    income_range_cd 2
    education_level_cd 1
    home_ownership_cd 1
    num_minors 1
    num_adults 2

    factory :no_season_demographics do
      season {nil}
    end

    factory :invalid_demographics do
      num_minors nil
    end
  end

  factory :tutor do
    association :user, :factory => :tutor_user
  end

  factory :manager do
    association :user, :factory => :manager_user
  end

  factory :parent do
    association :user, :factory => :parent_user
    factory :parent_with_current_demographic_profile do
      after(:build) do |p|
        p.user.is_parent =true
        p.demographics << FactoryGirl.create_list(:demographic, 1)
      end

      factory :parent_with_old_student_registrations do
        ignore do
          student_count 2
        end

        after(:create) do |parent, evaluator|
          FactoryGirl.create_list(:student_with_old_registration, evaluator.student_count, :parent => parent)
        end
      end
      factory :parent_with_current_student_registrations do
        ignore do
          student_count 2
        end

        after(:create) do |parent, evaluator|
          FactoryGirl.create_list(:student_with_registration, evaluator.student_count, :parent => parent)
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
    association :student, :factory => :student
    school "Hard Knocks"
    grade 5
    size_cd 2
    season  {Season.current }

    factory :paid_registration do
      status StudentRegistration.statuses(:confirmed_paid)
    end

    factory :old_registration do
      season {Season.where(:current =>false).first}
    end
  end

  factory :payment do
    amount 19.99
    before(:create) do |payment|
      FactoryGirl.create(:parent)
    end

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



  factory :season  do |f|
    fall_registration_open '2013-06-01'
    spring_registration_open '2013-12-01'
    beg_date '2013-09-22'
    end_date '2014-06-06'
    fencing_fee 50.00
    aep_fee 25.00
    current true
    status "Open"
    open_enrollment_date 2.days.ago.to_date

    factory :prev_season do
      fall_registration_open '2012-06-22'
      spring_registration_open '2012-12-22'
      beg_date '2012-09-22'
      end_date '2013-06-06'
      status "Closed"
      current false
    end
  end

  factory :aep_registration do
    association :student_registration, :factory => :paid_registration
    season  {Season.current } 

    factory :complete_aep_registration do
      student_academic_contract true
      parent_participation_agreement true 
      transcript_test_score_release true

      factory :paid_aep_registration do
        payment_status_cd 1
      end

    end
  end

  factory :aep_session do
    session_date  Date.today
  end

  factory :workshop do
    sequence(:name){|n| "Wok-Worky#{n}"}
  end

  factory :attendance do
    student_registration
    date Date.today
  end

  factory :subject do
    name "something"
  end

  factory :grade do
    report_card
    subject

    factory :number_grade do
      value 80
    end

    factory :A_F_grade do
      value 'S'
    end

    factory :E_U_grade do
      value 'S'
    end
  end

  factory :report_card do
    student_registration
    marking_period_type_cd 0
    marking_period 1


    factory :number_grade_report do
      format_cd 0
      after(:create) do |rp|
        FactoryGirl.create_list(:number_grade, 2, :report_card => rp)
      end
    end

    factory :letter_grade_report do
      factory :A_to_F_letter_grade_report do
        format_cd  1
        after(:create) do |rp|
          FactoryGirl.create_list(:A_F_grade, 2, :report_card => rp)
        end
      end

      factory :E_to_U_letter_grade_report do
        format_cd 2
        after(:create) do |rp|
          FactoryGirl.create_list(:E_U_grade, 2, :report_card => rp)
        end
      end
    end
  end

  factory :tutoring_assignment do
    association :tutor
    association :aep_registration, :factory => :complete_aep_registration
  end

  factory :session_report do
    association :tutor
    association :aep_registration, :factory => :complete_aep_registration
    factory :valid_session_report do
      session_date  Date.strptime("09/15/2013", "%m/%d/%Y") #Date.today.to_s
      worked_on_cd 1
      preparation 1
      participation 1
      motivation 1
      comprehension 1

      factory :confirmed_session_report do
        confirmed true
      end
    end
  end

  factory :monthly_report do
    association :tutor
    association :aep_registration, :factory => :complete_aep_registration
    factory :valid_monthly_report do
      month Date.today.month 
      year  Date.today.year
      num_hours_with_student 10
      num_preparation_hours 5
      student_goals "Something"
      goals_achieved false
      progress_notes "Nothing"
      new_goals_set true
      new_goals_desc "Something Else"
      issues_concerns "He Cray Cray"
      issues_resolution "Lock him up"

      factory :confirmed_monthly_report do
        confirmed true
      end
    end

  end
  factory :year_end_report do
    association :tutor
    association :aep_registration, :factory => :complete_aep_registration
    factory :valid_year_end_report do
      attendance "always here"
      preparation "always prepared"
      participation "always participates"
      academic_skills "got skillz"
      challenges_concerns "Ain't Skerred"
      achievements "junior"
      recommendations "the chicken"
      comments "blah"
      factory :confirmed_year_end_report do
        confirmed true
      end
    end
  end
end
