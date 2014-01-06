class ReportCard < ActiveRecord::Base
  belongs_to :student_registration
  belongs_to :marking_period
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true 
  attr_accessible :student_registration_id, :marking_period_id, :format_cd, :grades_attributes

  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true
  validates_uniqueness_of :marking_period_id, scope: [:student_registration_id]
  validates :student_registration, :marking_period, :format_cd, presence: true
  mount_uploader :transcript, TranscriptUploader

  before_create :set_season_id
  before_save :set_normalized_average

  def marking_period_name
    MarkingPeriod::PERIODS[marking_period]
  end

  def student_name
    student.nil? ? "invalid" : student.name 
  end

  def student_id
    student.nil? ? "000000" : student.id
  end

  def grade_average
    return 0 if normalized_grades.empty?
    normalized_grades.sum/normalized_grades.count
  end


   def normalized_grades
     @normalized ||= grades.map(&:normalize_to_hundred_point)
   end

   private

   def set_normalized_average
      self.normalized_avg = normalized_grades.inject{ |sum, el| sum + el }.to_f / normalized_grades.size
   end

   def set_season_id
    self.season_id = student_registration.season_id
  end

end
