class ReportCard < ApplicationRecord

  attr_accessor :transcript_pages

  has_one_attached :transcript
  belongs_to :student_registration
  belongs_to :marking_period
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  accepts_nested_attributes_for :grades, allow_destroy: true

  validates_uniqueness_of :marking_period_id, scope: [:student_registration_id, :academic_year], message: "Student already has a report card for this marking period and academic year"
  validates :student_registration, :academic_year, :marking_period, presence: true
  validate  :transcript_uploaded

  scope :current, ->{includes(:student_registration).references(:student_registration).where("student_registrations.season_id = ?", Season.current.id)}
  scope :previous, ->{joins(:student_registration).where.not("student_registrations.id =?", Season.current)}
  scope :graded, ->{includes(:grades).references(:grades).where.not(grades: {id: nil})}
  scope :not_graded, ->{includes(:grades).references(:grades).where(grades: {id: nil})}
  scope :with_transcript, ->{joins(:transcript_attachment).where('active_storage_attachments.created_at <= ?', Time.now)}
  scope :by_academic_year,  ->(school_year){where(academic_year: school_year)}
  scope :by_marking_period,  ->(period){where(marking_period: period)}
  scope :by_year_and_marking_period,  ->(school_year, period){by_academic_year(school_year).by_marking_period(period)}

  delegate :slug,  to: :season, prefix: true
  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true

  before_validation :attach_pages_if_present, :set_academic_year
  before_create :set_student
  after_create :update_invalid_current_registration

  def self.academic_years 
    Season.all.map(&:term)
  end

  def self.in_wrong_season
    where("transcript is not null and season_id = ? and created_at < ?",Season.current.id,  Season.current.beg_date)
  end

  def marking_period_name
    marking_period.name
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

  def slug
    "#{marking_period_name}: #{season.slug}"
  end

  def description
    "#{marking_period_name}-#{academic_year}"
  end

  def subject_list
    Subject.all.as_json(only: [:id,:name])
  end


  def reassign_to_last_season
    if student.previous_registration
      self.season_id = Season.previous_season_id 
      self.student_registration_id = student.previous_registration.id
    end
    save
  end

  def transcript_modified?
    @transcript_modified
  end

  def average
    return 0 if grades.empty?
    num = grades.map(&:score).sum/grades.count
    num.round(2)
  end

 private

  def update_invalid_current_registration
    if student.current_registration && student.current_registration.blocked_on_report_card?
      tracker = StudentReportCardTracker.new student, student_registration.season.academic_year
      tracker.unblock_current_registration
    end
  end


  def attach_pages_if_present
    if transcript_pages.present? && marking_period.present?
      pdf = FileUploadToPdf.combine_uploaded_files transcript_pages
      transcript.attach(io: pdf, filename: "#{slug}.pdf", content_type: "application/pdf")
      @transcript_modified= true
    end

  rescue FileUploadToPdf::IncompatibleFileTypeForMergeError
    errors.add(:transcript_pages, "All files must be of the same file type")
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

  def set_academic_year
    self.academic_year = season.academic_year if self.academic_year.nil?
  end

end
