FactoryBot.define do
  factory :student  do |f|
    f.sequence(:first_name) { |n| "foo_child#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.dob "2000-09-18"
    f.gender "M"
    f.ethnicity "African American"
    f.association :parent, :factory => :parent

    factory :student_with_old_registration do
      after(:create) do |student|
        FactoryBot.create_list(:old_registration, 1, :student => student)
      end
    end

    factory :student_with_registration do
      after(:create) do |student|
        FactoryBot.create_list(:student_registration, 1, :student => student)
      end
    end
  end
end
