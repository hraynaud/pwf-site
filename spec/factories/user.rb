FactoryBot.define do

  factory :user  do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:first_name) { |n| "foo#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.password "foobar"
    f.password_confirmation { |u| u.password }
    address1 { "123 Main Street" }
    city { "Anywhere" }
    state { "NY" }
    zip { "11234" }
    primary_phone { "555-123-4567" }
  end
end
