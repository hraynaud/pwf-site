require Rails.root.join("spec/support/stripe.rb")



FactoryBot.define do
  factory :letter_to_number_grade_converter do
    letter "A"
    scale "A-F"
    min 90
    max 100

  end



  factory :tutor do
    association :user, :factory => :tutor_user
  end

  factory :manager do
    association :user, :factory => :manager_user
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




  factory :tutoring_assignment do
    association :tutor
    association :aep_registration, :factory => :complete_aep_registration
  end

  factory :session_report do
    association :tutor
    association :tutoring_assignment
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
    association :tutoring_assignment
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
