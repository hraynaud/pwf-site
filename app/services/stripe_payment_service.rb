class StripePaymentService

  attr_reader  :error, :charge_id
  ERROR_MSG_INTRO ="!!!! Stripe error while creating payment:"
 
  def initialize(payment)
    @payment = payment
    @amount = (payment.amount*100).to_i
    @logger = Logger.new(STDOUT)
  end

  def create
    begin
      charge = create_stripe_charge!
      @charge_id = charge.id
      return self
    end
  rescue Stripe::InvalidRequestError => e
    @error = e.message
    @logger.error  "#{ERROR_MSG_INTRO} #{@error}"
    return self
  end 

  def succeeded?
    not charge_id.nil?
  end

  def create_stripe_charge!
    Stripe::Charge.create(
      amount: @amount,
      currency: "usd",
      card: @payment.stripe_card_token, # obtained with Stripe.js
      description: @payment.item_description,
      metadata: @payment.metadata
    )
  end
end
