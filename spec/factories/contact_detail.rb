FactoryBot.define do 
  factory :contact_detail do
    address1 { "123 Main Street" }
    city { "Anywhere" }
    state { "NY" }
    zip { "11234" }
    primary_phone { "555-123-4567" }
  end

  trait :invalid do
    zip {nil}
  end

end
