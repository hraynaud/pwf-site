class Parent < ActiveRecord::Base
  has_many :students
  has_many :student_registrations, :through => :students
  has_one :demographics
  accepts_nested_attributes_for :demographics


  devise :database_authenticatable, :registerable,:recoverable, :validatable
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :address1, :address2, :city, :state, :zip, :primary_phone, :secondary_phone, :other_phone, :demographics_attributes

  validates :first_name, :last_name, :address1, :city, :state, :zip, :primary_phone , :presence => true, :on => :update
  validates :primary_phone, :format => {:with =>/\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :on => :update
  validates :secondary_phone, :other_phone, :format => {:with => /\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :allow_blank => true
  validates :demographics, :presence => :true, :on => :update

  def self.with_current_registrations
    self.joins(:students => :student_registrations).where("student_registrations.season_id = ?", Season.current.id).uniq
  end


  def registration_complete?
    address1 && city && state && zip && primary_phone
  end


  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end

  def current_student_registrations
    student_registrations.current
  end

  def has_current_student_registrations
    current_student_registrations != []
  end
end

