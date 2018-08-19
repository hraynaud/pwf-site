FactoryBot.define do
  factory :report_card do
    association :student_registration
    marking_period_type_cd 0
    marking_period 1


    factory :number_grade_report do
      format_cd 0
      after(:create) do |rp|
        FactoryBot.create_list(:number_grade, 2, :report_card => rp)
      end
    end

    factory :letter_grade_report do
      factory :A_to_F_letter_grade_report do
        format_cd  1
        after(:create) do |rp|
          FactoryBot.create_list(:a_f_grade, 2, :report_card => rp)
        end
      end

      factory :E_to_U_letter_grade_report do
        format_cd 2
        after(:create) do |rp|
          FactoryBot.create_list(:e_u_grade, 2, :report_card => rp)
        end
      end
    end
  end
end
