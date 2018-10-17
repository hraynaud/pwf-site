class ReportCard < ApplicationRecord

  has_one_attached :transcript
  belongs_to :student_registration
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true

  validates_uniqueness_of :marking_period, scope: [:student_id, :academic_year], message: "Student already has a report card for this marking period and academic year"
  validates :student_registration, :academic_year, :marking_period,:transcript, presence: true
  validate  :transcript_uploaded

  scope :current, ->{joins(:season).merge(Season.current)}
  scope :with_grades, ->{joins(:grades).select("report_cards.id, report_cards.student_registration_id").uniq}

  delegate :slug,  to: :season, prefix: true
  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true

  after_validation :set_transcript_modified

  before_validation :set_student

  def self.academic_years 
    Season.all.map(&:term)
  end

  def self.in_wrong_season
    where("transcript is not null and season_id = ? and created_at < ?",Season.current.id,  Season.current.beg_date)
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

  def has_grades?
    grades.any?
  end

  def description
    "#{marking_period_name}-#{academic_year}"
  end

  def transcript_modified?
    @transcript_modified
  end

  def reassign_to_last_season
    if student.previous_registration
      self.season_id = Season.previous_season_id 
      self.student_registration_id = student.previous_registration.id
    end
    save
  end

  private

  def set_transcript_modified
     @transcript_modified = changed.include?("transcript")
  end

  def transcript_uploaded
    unless transcript.attached?
      errors.add(:transcript, "file must be attached")
      return false
    end
  end

  def set_student
    self.student_id = student.id
  end

end
