FactoryBot.define do
  factory :report_card do
    association :student_registration
    marking_period_type_cd { 0 }
    marking_period { 1 }
    academic_year { "2017-2018" }
    format_cd {GradeConversionService::HundredPointConverter.index}
    trait :with_transcript do
      transcript { AttachmentHelper.pdf('transcript1.pdf')}
    end

    trait :invalid do
      marking_period { nil }
    end

    trait :number_grade do
      after(:create) do |rp|
        FactoryBot.create_list(:number_grade, 2, :report_card => rp)
      end
    end

    trait :a_to_f_letter_grade do
      format_cd  { GradeConversionService::LetterConverter.index}
      after(:create) do |rp|
        FactoryBot.create_list(:a_f_grade, 2, :report_card => rp)
      end
    end

    trait :e_to_u_letter_grade do
      format_cd { 2 }
      after(:create) do |rp|
        FactoryBot.create_list(:e_u_grade, 2, :report_card => rp)
      end
    end
  end
end
