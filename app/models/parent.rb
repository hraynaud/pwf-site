class Parent < User
  has_many :students
  has_many :student_registrations, :through => :students
  has_many :aep_registrations, :through => :student_registrations
  has_many :report_cards, :through => :student_registrations
  has_many :demographics
  has_one  :current_household_profile, -> {joins(:season).where("seasons.current is true")},:class_name => "Demographic" 
  has_many :payments
  has_one_attached :photo

  attr_accessor :avatar_changed

  scope :with_current_registrations, ->{
    joins(:students)
      .joins(:student_registrations)
      .merge(StudentRegistration.current).distinct
  }


  class << self
    def by_status status
      with_current_registrations.merge(StudentRegistration.send(status))
    end

    def ordered_by_name
      select(:id, :first_name, :last_name).order('last_name asc, first_name asc')
    end

    def with_pending_registrations
      by_status :unpaid
    end

    def with_paid_registrations
      by_status :paid
    end

    def with_confirmed_registrations
      by_status :confirmed
    end

    def with_wait_listed_registrations
      by_status :wait_listed
    end

    def with_current_registrations_count
      with_current_registrations.count
    end

    def with_current_aep_registrations
      with_current_registrations.joins(:aep_registrations).where("aep_registrations.season_id = ?", Season.current.id).references(:aep_registrations)
    end

    def not_in_aep
      StudentRegistration.not_in_aep.joins(:parent).map(&:parent).uniq.sort_by{|p|p.name}
    end

    def in_aep
      StudentRegistration.in_aep.joins(:parent).map(&:parent).uniq.sort_by{|p|p.name}
    end
  end

  def current_unpaid_aep_registrations_count 
    current_unpaid_aep_registrations.count
  end

  def current_unpaid_aep_registrations
    aep_registrations.current.unpaid
  end

  def current_unpaid_aep_registration_amount
    current_unpaid_aep_registrations_count * Season.current.aep_fee
  end

  def has_unpaid_aep_registrations?
    current_unpaid_aep_registrations.count > 0
  end

  def students_count
    students.count
  end

  def student_by_id id
    students.find(id)
  end

  def registrations_count
    student_registrations.count
  end

  def unpaid_registrations_count
    unpaid_registrations.count
  end

  def unpaid_registrations
    student_registrations.unpaid
  end

  def confirmed_registrations
    student_registrations.confirmed
  end

  def confirmed_registrations_count
    confirmed_registrations.count
  end

  def withdrawn_registrations_count
    withdrawn_registrations.count
  end

  def withdrawn_registrations
    student_registrations.withdrawn
  end

  def has_current_unpaid_fencing_registrations?
    student_registrations.unpaid != []
  end

  def curr_registration_complete?
    current_household_profile && contact_detail
  end


  private

  #TODO could this be a student_registration valid?
  #IE prevent student reg from being created unless there is a current parent profile?
  def must_have_current_household_profile
    if  persisted? && !current_household_profile
       errors.add(:base, "Current demographic profile is out of date")
    end
  end

  def avatar_image_changed
    avatar_changed?
  end

end
