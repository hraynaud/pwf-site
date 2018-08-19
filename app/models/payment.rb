class Payment < ApplicationRecord
  include PayPalSupport
  belongs_to :parent
  belongs_to :season
  has_many :student_registrations, :through => :parent
  has_many :aep_registrations, :through => :parent
  has_many :paid_fencing_registrations, class_name: "StudentRegistration"
  has_many :paid_aep_registrations, class_name: "AepRegistration"

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

  before_validation :set_season, :process_online_payment
  after_save :confirm_registrations, :set_completed

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

  def process_online_payment
    do_card_charge and return if with_card?
    #do_paypal_charge(PaypalPaymentService.new(self).create) and return if with_paypal?
  end

  def with_paypal
    false
  end

  def do_paypal_charge charge
  end

  def do_card_charge 
    if stripe_charge_id.blank?
      charge = StripePaymentService.new(self).create
      charge.succeeded? ? stripe_success(charge.charge_id) : stripe_failure(charge.error)
    end
  end

  def stripe_success(charge_id)
    self.stripe_charge_id = charge_id
  end

  def set_completed
    update_column(:completed, true)
  end

  def stripe_failure(error)
    @payment.errors.add error
    return false
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

  def item_description
    "Peter Westbrook Foundation: #{program_description} Program Registration: #{Season.current.term}\n #{parent.name}\n #{payments_for}"
  end

  private

  def registrations_paid
    @paid_registrations ||= fencing? ? paid_fencing_registrations : paid_aep_registrations
  end

  def registrations_to_be_paid
    @registrations_to_be_paid ||= fencing? ? student_registrations.current.pending : aep_registrations.current.unpaid
  end

  def confirm_registrations
    unpaid_registrations.each do |reg|
      reg.mark_as_paid self
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
    check?
  end

  def recurring_payment_description
    "Monthly charge for #{item_description}"
  end

  def instant_payment_description
    "Instant for #{item_description}"
  end

  def is_stripe_payment?
    stripe_card_token.present?
  end

  def is_paypal_payment?
    !is_stripe_payment?
  end
end
