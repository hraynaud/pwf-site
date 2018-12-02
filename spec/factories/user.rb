FactoryBot.define do

  factory :user  do
    sequence(:email) { |n| "foo#{n}@example.com" }
    sequence(:first_name) { |n| "foo#{n}" }
    sequence(:last_name) { |n| "bar#{n}" }
    password {"foobar"}
    password_confirmation { |u| u.password }
    address1 { "123 Main Street" }
    city { "Anywhere" }
    state { "NY" }
    zip { "11234" }
    primary_phone { "555-123-4567" }

    trait :invalid do
      password {nil}
    end

  end
end
