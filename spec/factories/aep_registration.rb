FactoryBot.define do
  factory :aep_registration do
    association :student_registration, :factory => :student_registration
    season_id  {Season.current.id } 

    factory :complete_aep_registration do
      student_academic_contract true
      parent_participation_agreement true 
      transcript_test_score_release true

      factory :paid_aep_registration do
        payment_status_cd 1
      end

    end
  end
end

