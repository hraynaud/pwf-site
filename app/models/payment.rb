class Payment < ActiveRecord::Base
  include PayPalSupport
  belongs_to :parent
  belongs_to :season
  has_many :student_registrations, :through => :parent
  has_many :aep_registrations, :through => :parent
  attr_accessor :stripe_card_token, :paypal_payment_token, :email, :first_name, :last_name, :pay_with
  attr_reader :redirect_uri, :popup_uri

  delegate :email, :name, :to => :parent, :prefix => true

  validates :token, uniqueness: true, :if => :is_stripe_payment?, :on => :create, :allow_nil => :true
  validates :amount, presence: true
  validates :identifier, uniqueness: true, :if => :is_paypal_payment?, :on => :update, :allow_nil => :true
  validates :parent, :presence => true
  after_save :confirm_registrations
  validates :method, :presence => :true
  as_enum :method, [:online, :check, :cash]
  as_enum :program, [:fencing, :aep]

  validates :check_no, :presence => true, :if => :by_check?
  before_validation :set_season

  def self.current
    where(:season_id => Season.current.id)
  end

  def self.by_check_or_cash
    methods_for_select.reject do |x|
      x.last==:online
    end
  end

  def save_with_stripe!
    if valid?
      charge = create_stripe_charge!
      self.stripe_charge_id = charge.id
      self.completed = true
      save!

    end
  rescue Stripe::InvalidRequestError => e
    logger.error "!!!! Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card. #{e.message}"
    false
  rescue => e
    errors.add :base, "There was a problem with this payment. #{e.message}"
    false
  end

  def create_stripe_charge!
    Stripe::Charge.create(
      :amount => (amount*100).to_i,
      :currency => "usd",
      :card => stripe_card_token, # obtained with Stripe.js
      :description => item_description
    )
  end

  def save_with_paypal!(return_url, cancel_url)
    response = paypal_client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: self.digital?
    )
    self.token = response.token
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self.save!
    self
  rescue => e
    errors.add :base, "There was a problem with this payment. #{e.message}"
    @redirect_uri = cancel_url
  end

  def paypal_complete!(payer_id = nil)
    if self.recurring?
      response = paypal_client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = paypal_client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end
    self.completed = true
    self.save!
    self
  end


  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def payment_details_validated?
    stripe_card_token.present? || paypal_payment_token.present?
  end

  def is_completed?
    completed
  end

  def payments_for
    studs = []
    regs = attached_registrations
    regs.each do |reg|
      studs << reg.student_name
    end
    studs.join(",")
  end

  def attached_registrations
   @attached_regs || self.fencing? ? student_registrations : aep_registrations
  end

  def confirm_registrations
    if completed
      attached_registrations.current.unpaid.each do |reg|
        reg.mark_as_paid self
      end
    end
  end

  private

  def set_season
    self.season = Season.current
  end

  def by_check?
    true if check?
  end

  def item_description
    "Peter Westbrook Foundation Registration: #{Season.current.term}\n #{parent.name}\n #{payments_for}"
  end


  def recurring_payment_description
    "Monthly charge for #{item_description}"
  end

  def instant_payment_description
    "Instant for #{item_description}"
  end


  def is_stripe_payment?
    # pay_with=="card"
    stripe_card_token.present?
  end

  def is_paypal_payment?
    !is_stripe_payment?
  end


end
