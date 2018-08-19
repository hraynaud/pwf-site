FactoryBot.define do
  factory :grade do
    report_card
    subject

    factory :number_grade do
      value 80
    end

    factory :a_f_grade do
      value 'A'
    end

    factory :e_u_grade do
      value 'S'
    end
  end
end
