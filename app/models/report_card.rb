class ReportCard < ActiveRecord::Base
  belongs_to :student_registration
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true 
  attr_accessible :student_registration_id, :season_id, :academic_year, :marking_period, :format_cd, :grades_attributes

  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true
  mount_uploader :transcript, TranscriptUploader

  before_create :set_season_id, :set_student

	validates_uniqueness_of :marking_period, scope: [:student_id, :academic_year], message: "Student already has a report card for this marking period and academic year"
  validates :student_registration, :academic_year, :marking_period, presence: true

  def self.academic_years
  Season.all.map(&:term)
  end

  def marking_period_name
    MarkingPeriod.name_for(marking_period)
  end

  def student_name
    student.nil? ? "invalid" : student.name 
  end

  def student_id
    student.nil? ? "000000" : student.id
  end



   private

	 def set_student
    self.student_id = student.id
	 end
   def set_season_id
		 self.season_id = student_registration.season_id if season_id.nil?
  end

end
