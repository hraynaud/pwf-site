require 'paypal/express'

PAYPAL_CONFIG = {
    username:  ENV['PAYPAL_USERNAME'],
    password:  ENV['PAYPAL_PASSWORD'],
    signature: ENV['PAYPAL_SIGNATURE'],
    sandbox:   ENV['PAYPAL_SANDBOX']
  }
Paypal.sandbox! if PAYPAL_CONFIG[:sandbox]
