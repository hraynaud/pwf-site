class StudentRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student
  belongs_to :payment
  has_many :attendances
  has_many :grades
  has_many :aep_registrations
  has_many :report_cards
  has_one :parent, :through => :student
  attr_accessible :school, :grade, :size_cd, :medical_notes, :academic_notes, :academic_assistance, :student_id, :season_id, :status_cd

  before_create :get_status
  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates :student, :presence => true, :on => :save
  delegate :name, :dob, :gender, :age, :to => :student,:prefix => true

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  STATUS_VALUES = ["Pending", "Confirmed Fee Waived", "Confirmed Paid", "Wait List", "Withdrawn" ]
  as_enum :status, STATUS_VALUES.each_with_index.map{|v, i| [v.parameterize.underscore.to_sym, i]}

  def self.unpaid
    where(status_cd: statuses.pending)
  end

  def self.paid
    where(status_cd: statuses.confirmed_paid)
  end

  def self.fee_waived
    where(status_cd: statuses.confirmed_fee_waived)
  end

  def self.enrolled
    where(status_cd: statuses(:confirmed_fee_waived, :confirmed_paid))
  end

  def self.wait_listed
    where(status_cd: statuses.wait_list)
  end
 
  def self.current_wait_listed
    current.wait_listed
  end

  def self.current_wait_listed_count
   current_wait_listed.count
  end

  def self.wait_listed_count
   wait_listed.count
  end

  def self.current
    where(:season_id => Season.current_season_id)
  end

  def self.previous_season
    where(:season_id => Season.previous_season_id)
  end

  def self.current_count
    current.count
  end

  def self.inactive
    where("season_id != ?",Season.current.id)
  end

  def paid?
    !payment_id.nil?
  end

  def season_description
    season.description
  end

  def active?
    season.is_current?
  end

  def student_name
    student.name
  end

  def unconfirmed?
    self.class.statuses.except(:confirmed_fee_waived, :confirmed_paid).include? status
  end

  def confirmed
    !unconfirmed?
  end

  def mark_as_paid(payment)
    self.payment = payment
    self.status = :confirmed_paid 
    save!
  end



  private
  def get_status
    if Season.current && Season.current.status == "Wait List"
      self.status = :wait_list
    else
      self.status = :pending 
    end
  end

end
