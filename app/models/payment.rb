class Payment < ApplicationRecord
  belongs_to :parent
  belongs_to :season
  has_many :student_registrations, :through => :parent
  has_many :aep_registrations, :through => :parent
  has_many :paid_fencing_registrations, class_name: "StudentRegistration"
  has_many :paid_aep_registrations, class_name: "AepRegistration"

  validates :amount, presence: true
  validates :first_name,:last_name, :email, :presence => true
  validates :parent, :presence => true
  validates :payment_medium, :presence => :true
  validates :check_no, :presence => true, :if => :by_check?

  delegate :email, :name, :full_address, :to => :parent, :prefix => true
  delegate :description, :to => :season, :prefix => true
  attr_accessor :stripe_card_token, :email, :first_name, :last_name, :pay_with

  before_validation :set_season, :process_online_payment
  after_save :confirm_registrations, :set_completed

  CARD = "card"

  as_enum :payment_medium, [:online, :check, :cash, :waived]
  as_enum :program, [:fencing, :aep]

  def self.current
    where(:season_id => Season.current.id)
  end

  def self.by_check_or_cash
    payment_media.hash.reject{|k,v| k=="online"}
  end

  def total_payment
    affected_registrations_count * program_fee
  end

  def program_fee
    Season.current.fee_for(program)
  end

  def process_online_payment
    do_stripe_charge and return if with_card?
  end

  def do_stripe_charge 
    if stripe_charge_id.blank?
      charge = StripePaymentService.new(self).create
      charge.succeeded? ? stripe_success(charge.charge_id) : stripe_failure(charge.error)
    end
  end

  def stripe_success(charge_id)
    self.stripe_charge_id = charge_id
  end

  def stripe_failure(error)
    @payment.errors.add error
    return false
  end

  def set_completed
    update_column(:completed, true)
  end

  def processor
    if online? 
       "Stripe"
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
    stripe_card_token.present?
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

  def with_card?
    pay_with == CARD
  end

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

  def is_stripe_payment?
    stripe_card_token.present?
  end

end
