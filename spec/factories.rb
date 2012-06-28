FactoryGirl.define do

  factory :parent  do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.sequence(:first_name) { |n| "foo#{n}" }
    f.sequence(:last_name) { |n| "bar#{n}" }
    f.password "foobar"
    f.password_confirmation { |u| u.password }
  end

  factory :complete_parent, :parent => :parent  do |f|
    f.address1 "123 Main Street"
    f.city "Anywhere"
    f.state "New York"
    f.zip "11234"
    f.primary_phone "555-123-4567"
  end
end
