class ReportCard < ActiveRecord::Base
  belongs_to :student_registration
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true 
  attr_accessible :student_registration_id, :marking_period, :format_cd, :grades_attributes
  mount_uploader :transcript, TranscriptUploader

  delegate :name, to: :student, prefix: true
  delegate :term, to: :season

  validates :student_registration, presence: true

  def marking_period_name
    MarkingPeriod::PERIODS[marking_period]
  end
end
