class User < ApplicationRecord
  devise :database_authenticatable, :registerable,:recoverable, :validatable
  has_one :contact_detail

  attr_accessor :current_step

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

