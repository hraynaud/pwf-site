class StudentRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student
  attr_accessible :school, :grade, :size_cd, :medical_notes, :academic_notes, :academic_assistance, :student_id

  before_create :get_status
  validates :season, :school, :grade, :size_cd,  :presence => :true
  validates :student, :presence => true, :on => :save

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  as_enum :status, ["Pending", "Pending Paid", "Confirmed", "Confirmed Paid", "Wait List"]


  def self.wait_listed
    where(:status_cd => statuses["Wait List"] )
  end
  def active?
    season.is_current?
  end

  def student_name
    student.name
  end

  def unconfirmed?
    self.class.statuses.except("Confirmed","Confirmed Paid").include? status
  end

  def confirmed
    !unconfirmed?
  end

  def self.current
    where(:season_id => Season.current.id)
  end

  def self.inactive
    where("season_id != ?",Season.current.id)
  end

  private
  def get_status
    if Season.current && Season.current.status == "Wait List"
      self.status = "Wait List"
    else
      self.status = "Pending"
    end
  end

end
