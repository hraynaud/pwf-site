FactoryBot.define do
  factory :aep_registration do
    association :student_registration,  :confirmed
    season_id  {Season.current.id } 

    trait :complete do
      student_academic_contract true
      parent_participation_agreement true 
      transcript_test_score_release true
    end

    trait :paid do
      payment_status_cd 1
    end

  end
end

