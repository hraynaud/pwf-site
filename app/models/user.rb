class User < ActiveRecord::Base

  belongs_to :profileable, :polymorphic => true
  devise :database_authenticatable, :registerable,:recoverable, :validatable
 
  attr_writer :current_step
  validates :first_name, :last_name, :address1, :city, :state, :zip, :primary_phone,  :presence => true, :if => :on_contact_step?
  validates :primary_phone, :format => {:with =>/\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :if => :on_contact_step?
  validates :secondary_phone, :other_phone, :format => {:with => /\A(\d{3})-(\d{3})-(\d{4})\Z/, :message => "Please enter a phone numbers as: XXX-XXX-XXXX"}, :allow_blank => true

  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, 
    :address1, :address2, :city, :state, :zip, :primary_phone, :secondary_phone, 
    :other_phone, :demographics_attributes


  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end

  def steps
    %w[account contact demographics]
  end

  def current_step
    @current_step || steps.first
  end

  def current_step_index
    steps.index(current_step)
  end

  def friendly_current_step_index
    current_step_index + 1
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end



  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    res = steps.all? do |step| #NOTE: cool ruby-foo all? http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-all-3F
      self.current_step = step
      valid?
    end
  end

  private
  
  def default_steps

  end

  def on_contact_step?
    current_step == "contact"
  end


end

