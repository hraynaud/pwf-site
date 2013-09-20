class ReportCard < ActiveRecord::Base
  belongs_to :student_registration
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true 
  attr_accessible :student_registration_id, :marking_period, :format_cd, :grades_attributes

  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true
  validates_uniqueness_of :marking_period, scope: [:student_registration_id]
  validates :student_registration, :marking_period, :format_cd, presence: true

  mount_uploader :transcript, TranscriptUploader

  def marking_period_name
    MarkingPeriod::PERIODS[marking_period]
  end

  def student_name
    student.nil? ? "invalid" : student.name 
  end

  def student_id
    student.nil? ? "000000" : student.id
  end
end
