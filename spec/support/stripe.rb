module StripeHelper
  STRIPE_TOKEN_REQ_GOOD =/https:\/\/api\.stripe.com\/v1\/tokens\/.+/
    STRIPE_TOKEN_RESP_GOOD =' {
    "livemode": false,
    "created": 1337879345,
    "amount": 0,
    "object": "token",
    "used": false,
    "currency": "usd",
    "id": "tok_flGPh00f6X0W2b",
    "card": {
    "address_line1": null,
    "exp_month": 8,
    "type": "Visa",
    "address_line2": null,
    "exp_year": 2013,
    "fingerprint": "kj85xvF2AQby1oNy",
    "object": "card",
    "address_zip": null,
    "last4": "1111",
    "cvc_check": null,
    "country": "US",
    "address_state": null,
    "address_zip_check": null,
    "address_country": null,
    "name": null,
    "address_line1_check": null,
    "id": "cc_OtHc9Ley8cwsEz"
  }
  }'


  STRIPE_CHARGE_REQ_GOOD = "https://api.stripe.com/v1/charges"

  STRIPE_CHARGE_RESP_GOOD = '{
    "livemode": false,
    "refunded": false,
    "created": 1340739703,
    "description": "Charge for herbyraynaud@yahoo.com - Volo Vitamins Order-Payment id: 48",
    "amount": 597,
    "amount_refunded": 0,
    "object": "charge",
    "disputed": false,
    "failure_message": null,
    "customer": null,
    "fee_details": [
      {
    "type": "stripe_fee",
    "application": null,
    "description": "Stripe processing fees",
    "amount": 47,
    "currency": "usd"
  }
  ],
    "invoice": null,
    "fee": 47,
    "paid": true,
    "currency": "usd",
    "id": "ch_Ev5XUp5oDEv92c",
    "card": {
    "address_line1": null,
    "exp_month": 1,
    "type": "Visa",
    "address_line2": null,
    "exp_year": 2015,
    "fingerprint": "ETAD1XmXCmFClhIF",
    "object": "card",
    "address_zip": null,
    "last4": "1111",
    "cvc_check": "pass",
    "country": "US",
    "address_state": null,
    "address_zip_check": null,
    "address_country": null,
    "name": null,
    "address_line1_check": null,
    "id": "cc_HltbEqu4ByO4fQ"
  }
  }'

  INVALID_REQUEST_ERROR = '{
    "error": {
    "type": "invalid_request_error",
    "message": "Amount must be at least 50c",
    "param": "amount"
  }
  }'



  VALID_TOKEN = "tok_flGPh00f6X0W2b"

  def self.setup
    FakeWeb.register_uri(:post, STRIPE_TOKEN_REQ_GOOD, :body => STRIPE_TOKEN_RESP_GOOD)
    FakeWeb.register_uri(:post, STRIPE_CHARGE_REQ_GOOD, :body => STRIPE_CHARGE_RESP_GOOD)
  end


end
