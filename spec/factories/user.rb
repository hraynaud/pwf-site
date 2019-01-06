FactoryBot.define do

  factory :user  do
    sequence(:email) { |n| "foo#{n}@example.com" }
    sequence(:first_name) { |n| "foo#{n}" }
    sequence(:last_name) { |n| "bar#{n}" }
    password {"foobar"}
    password_confirmation { |u| u.password }
    trait :invalid do
      password {nil}
    end

  end
end
