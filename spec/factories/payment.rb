require Rails.root.join("spec/support/stripe.rb")
FactoryBot.define do
  factory :payment do
    amount { 19.99 }

    parent factory: :parent

    trait :completed do
      completed { true }
    end

    factory :online_payment do

      factory :stripe_payment do
        email { "foo@example.com" }
        first_name { "foo" }
        last_name { "bar" }
        pay_with { "card" }
        payment_medium { "online" }
        stripe_card_token { StripeHelper::VALID_TOKEN }


        factory :zero_amount_payment do
          amount { 0 }
        end

        factory :stripe_payment_invalid_customer do
          email { "foo@example.@" }
        end
      end

      factory :paypal_payment do

      end
    end
  end
end
