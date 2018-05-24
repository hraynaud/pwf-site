module PayPalSupport
#This module to be included in an active record Payment model.
  extend ActiveSupport::Concern

  included do
    set_paypal_payment_scopes
    set_vendor_description
  end

  module ClassMethods
    def set_paypal_payment_scopes
      scope :recurring, where(recurring: true)
      scope :digital,   where(digital: true)
      scope :popup,     where(popup: true)
    end
    def set_vendor_description

    end
  end


  def paypal_client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  def goods_type
    digital? ? :digital : :real
  end

  def payment_type
    recurring? ? :recurring : :instant
  end

  def ux_type
    popup? ? :popup : :redirect
  end

  def paypal_unsubscribe!
    paypal_client.renew!(identifier, :Cancel)
    cancel!
  end

  def paypal_cust_details
    if recurring?
      paypal_client.subscription(identifier)
    else
      paypal_client.details(token)
    end
  end

   def payment_request
    request_attributes = if recurring?
                           {
                             billing_type: :RecurringPayments,
                             billing_agreement_description: recurring_payment_description
                           }
                         else
                           item = {
                             name: item_description,
                             description: item_description,
                             amount: amount
                           }
                           item[:category] = :Digital if digital?
                           {
                             amount: amount,
                             description: instant_payment_description,
                             items: [item]
                           }
                         end
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: recurring_payment_description,
      billing: {
      period: :Month,
      frequency: 1,
      amount: amount
    }
    )
  end

end
