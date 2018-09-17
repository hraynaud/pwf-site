require Rails.root.join("spec/support/stripe.rb")

FactoryBot.define do
  factory :letter_to_number_grade_converter do
    letter "A"
    scale "A-F"
    min 90
    max 100
  end
end
