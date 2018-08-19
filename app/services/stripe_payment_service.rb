class StripePaymentService

  attr_reader :description, :card_token, :amount, :error, :charge_id
  ERROR_MSG_INTRO ="!!!! Stripe error while creating customer or payment:"
 
  def initialize(payment)
    @payment = payment
    @card_token = payment.stripe_card_token
    @description = payment.item_description
    @amount = (payment.amount*100).to_i
    @error = nil
  end

  def create
    begin
      charge = create_stripe_charge!
      @charge_id = charge.id
      return self
    end
  rescue Stripe::InvalidRequestError => e
    @error = e.message
    logger.error = "#{ERROR_MSG_INTRO} #{@error}"
    return self
  end 

  def succeeded?
    not charge_id.nil?
  end

  def create_stripe_charge!
    Stripe::Charge.create(
      amount: amount,
      currency: "usd",
      card: card_token, # obtained with Stripe.js
      :description => description
    )
  end
end
