FactoryBot.define do

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
end
