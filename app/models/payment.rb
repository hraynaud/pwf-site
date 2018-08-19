class Payment < ApplicationRecord
  include PayPalSupport
  belongs_to :parent
  belongs_to :season
  has_many :student_registrations, :through => :parent
  has_many :aep_registrations, :through => :parent
  has_many :paid_fencing_registrations, class_name: "StudentRegistration"
  has_many :paid_aep_registrations, class_name: "AepRegistration"

  validates :token, uniqueness: true, :if => :is_stripe_payment?, :on => :create, :allow_nil => :true
  validates :amount, presence: true
  validates :identifier, uniqueness: true, :if => :is_paypal_payment?, :on => :update, :allow_nil => :true
  validates :first_name,:last_name, :email, :presence => true
  validates :parent, :presence => true
  validates :payment_medium, :presence => :true
  validates :check_no, :presence => true, :if => :by_check?

  delegate :email, :name, :full_address, :to => :parent, :prefix => true
  delegate :description, :to => :season, :prefix => true
  attr_accessor :stripe_card_token, :paypal_payment_token, :email, :first_name, :last_name, :pay_with
  attr_reader :redirect_uri, :popup_uri

  before_validation :set_season
  after_save :confirm_registrations
  CARD = "card"
  PAYPAL= "paypal"

  as_enum :payment_medium, [:online, :check, :cash, :waived]
  as_enum :program, [:fencing, :aep]


  def self.current
    where(:season_id => Season.current.id)
  end

  def self.by_check_or_cash
    payment_media.hash.reject{|k,v| k=="online"}
  end

  def with_card?
    pay_with == CARD
  end

  def total_payment
    affected_registrations_count * program_fee
  end

  def program_fee
    Season.current.fee_for(program)
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

  def processor
    if online? 
      token.present? ? "Paypal" : "Stripe"
    else
      payment_medium
    end
  end

  def identifier
    if online? 
      token || stripe_charge_id
    else
      id
    end
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
    affected_registrations.map(&:description).join("\n")
  end

  def affected_registrations
    @regs ||= if is_completed?
                registrations_paid
              else
                registrations_to_be_paid
              end
  end

  def affected_registrations_count
    affected_registrations.count
  end

  private

  def registrations_paid
    @paid_registrations ||= fencing? ? paid_fencing_registrations : paid_aep_registrations
  end

  def registrations_to_be_paid
    @registrations_to_be_paid ||= fencing? ? student_registrations.current.pending : aep_registrations.current.unpaid
  end

  def confirm_registrations
    if completed
      unpaid_registrations.each do |reg|
        reg.mark_as_paid self
      end
    end
  end


  def program_description
    self.fencing? ? "Saturday Fencing" : "Academic Enrichment"
  end

  def unpaid_registrations
    affected_registrations.current.unpaid
  end

  def set_season
    self.season = Season.current
  end

  def by_check?
    true if check?
  end

  def item_description
    "Peter Westbrook Foundation: #{program_description} Program Registration: #{Season.current.term}\n #{parent.name}\n #{payments_for}"
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
