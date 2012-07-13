class Payment < ActiveRecord::Base
  belongs_to :parent
  has_many :student_registrations
  attr_accessor :stripe_card_token, :paypal_payment_token, :email, :first_name, :last_name

  delegate :email, :name, :to => :parent, :prefix => true

  validates :token, uniqueness: true
  validates :amount, presence: true
  validates :identifier, uniqueness: true
  validates :parent, :presence => true

  scope :recurring, where(recurring: true)
  scope :digital,   where(digital: true)
  scope :popup,     where(popup: true)

  after_create :create_stripe_charge!, :if => :is_card_payment?

  def create_stripe_charge!()
    self.parent = get_parent
    charge = Stripe::Charge.create(
      :amount => (amount*100).to_i,
      :currency => "usd",
      :card => stripe_card_token, # obtained with Stripe.js
      :description => invoice_details
    )
    self.completed = true
    save
  rescue Stripe::InvalidRequestError => e
    logger.error "!!!! Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card. #{e.message}"
    false
  end

  #PAYPAL RELATED METHODS
  def details
    if recurring?
      client.subscription(self.identifier)
    else
      client.details(self.token)
    end
  end

  attr_reader :redirect_uri, :popup_uri
  def setup_paypal!(return_url, cancel_url)
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(payer_id = nil)
    if self.recurring?
      response = client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end
    self.parent = get_parent
    self.completed = true
    self.save!
    self
  end

  def payment_details_validated?
    stripe_card_token.present? || paypal_payment_token.present?
  end

  def is_completed?
    completed
  end

  def description
    "Payment id:#{id} Date: #{created_at.strftime('%y-%m-%d %H:%M')} Amount: #{amount}"
  end


  #UNUSED METHODS IN THIS IMPLEMENTATION

  def unsubscribe!
    client.renew!(self.identifier, :Cancel)
    self.cancel!
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


  private

  def invoice_details
    "Peter Westbrook Foundation Registration: #{Season.current.description}\n Invoice: #{self.id}\n"
  end

  def get_parent()
    if payment_method == "paypal"
      cust_details = details
      self.email = cust_details.payer.email
      self.first_name = cust_details.payer.first_name
      self.last_name = cust_details.payer.last_name
    end
  end

  def is_card_payment?
    payment_method=="card"
  end



  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end

  DESCRIPTION = {
    item: 'Volo Vitamins order payment',
    instant: 'Volo Vitamins instant payment',
    recurring: 'Volo Vitamins recurring order payment'
  }

  def payment_request
    request_attributes = if self.recurring?
                           {
                             billing_type: :RecurringPayments,
                             billing_agreement_description: DESCRIPTION[:recurring]
                           }
                         else
                           item = {
                             name: DESCRIPTION[:item],
                             description: DESCRIPTION[:item],
                             amount: self.amount
                           }
                           item[:category] = :Digital if self.digital?
                           {
                             amount: self.amount,
                             description: DESCRIPTION[:instant],
                             items: [item]
                           }
                         end
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: DESCRIPTION[:recurring],
      billing: {
      period: :Month,
      frequency: 1,
      amount: self.amount
    }
    )
  end

end
