class ContactDetail < ApplicationRecord
  belongs_to :user
  #TODO remove redundant in rails 5?
  validates_presence_of :user
  
  PHONE_REGEX= /\A\(?\d{3}\)?[- ]?\d{3}[- ]?\d{4}\z/
  PHONE_MESSAGE = "Please enter a valid phone number"

  validates  :address1, :city, :state, :zip, :primary_phone,  :presence => true
  validates :primary_phone, :format => {:with => PHONE_REGEX, :message => PHONE_MESSAGE}
  validates :secondary_phone, :other_phone, :format => {:with => PHONE_REGEX, :message => PHONE_MESSAGE}, :allow_blank => true

  def address
    "#{address1} #{address2} #{city} #{state}, #{zip}"
  end

end
