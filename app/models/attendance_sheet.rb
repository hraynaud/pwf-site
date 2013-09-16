class AttendanceSheet < ActiveRecord::Base
  has_many :attendances, :include => ({:student_registration => :student}), :dependent => :destroy, :order => "students.last_name asc"
  belongs_to :season
  attr_accessible :session_date, :attendances_attributes, :season_id
  accepts_nested_attributes_for :attendances

  validates :season_id, :session_date, presence: true
  validates_uniqueness_of :session_date

  delegate :term, to: :season

  def enrollment_as_of_date
     attendances.count
  end

end
