class User < ActiveRecord::Base

  belongs_to :profileable, :polymorphic => true
  devise :database_authenticatable, :registerable,:recoverable, :validatable
 
  attr_accessor :current_step
  validates :first_name, :last_name, :address1, :city, :state, :zip, :primary_phone,  :presence => true, :if => :on_contact_step?
  validates :primary_phone, :format => {:with =>/\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :if => :on_contact_step?
  validates :secondary_phone, :other_phone, :format => {:with => /\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :allow_blank => true

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end

  private

  def on_account_step?
    current_step == "account"
  end

  def on_contact_step?
    current_step == "contact"
  end


end

