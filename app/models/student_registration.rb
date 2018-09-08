class StudentRegistration < ApplicationRecord
  belongs_to :season
  belongs_to :student
  belongs_to :payment, optional: true
  belongs_to :group, optional: true
  has_many :attendances
  has_many :grades
  has_one :aep_registration
  has_many :report_cards
  has_one :parent, :through => :student

  before_create :set_status
  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates :student, :presence => true, :on => :save
  delegate :name, :dob, :gender, :age, :to => :student,:prefix => true
  delegate :id, :name, :to => :parent,:prefix => true
  delegate :term, to: :season

  #after_initialize :set_season, if: ->{new_record?}

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  STATUS_VALUES = ["Pending", "Confirmed Fee Waived", "Confirmed Paid", "Wait List", "Withdrawn", "AEP Only"]
  as_enum :status, STATUS_VALUES.map{|v| v.parameterize.underscore.to_sym}, pluralize_scopes:false 

  class << self
    def current
      where(:season_id => Season.current_season_id)
    end

    def current_confirmed
      @@current_confirmed = current.confirmed
    end

    def confirmed_students_count
      current_confirmed.count
    end

    def current_count
      current.count
    end

    def inactive
      where.not(id: current)
    end

    def status_options
      statuses.hash
    end

    def size_options
      sizes.hash
    end

    def unpaid
      pending
    end

    def paid
      confirmed_paid
    end

    def fee_waived
      confirmed_fee_waived
    end

    def confirmed
      confirmed_paid.or(confirmed_fee_waived)
    end

    def wait_listed
      wait_list
    end

    def current_wait_listed
      current.wait_listed
    end

    def current_wait_listed_count
      current_wait_listed.count
    end

    def wait_listed_count
      wait_listed.count
    end

    def with_valid_report_card
      where(report_card_submitted: true)
    end

    def ineligible
      where(report_card_submitted: false)
    end

    def previous_season
      where(:season_id => Season.previous_season_id)
    end

    def by_season id
      where(season_id: id)
    end

    def order_by_student_last_name
      select(:first_name, :last_name).joins(:student).order("students.last_name asc, students.first_name asc")
    end

    def in_aep
      StudentRegistration.current.confirmed.joins(:aep_registration)
    end

    def not_in_aep
      where.not(id: in_aep).current.confirmed
    end
  end

  def paid?
    !payment_id.nil?
  end

  def season_description
    season.description
  end

  def student_name
    student.name
  end

  def unconfirmed?
    not confirmed?
  end

  def confirmed?
    [:confirmed_paid, :confirmed_fee_waived].include? status
  end

  def mark_as_paid(payment)
    self.payment = payment
    self.status = :confirmed_paid 
    save
  end

  def description
    "Fencing #{student_name} - #{season.slug}"
  end

  def attendance_count
    attendances.any? ? attendances.count : 0;
  end

  def fee
    season.fencing_fee
  end

  private

 def set_season
   self.season = Season.current
 end

 def set_status
   self.status = :wait_list if season.wait_list?
 end

end

