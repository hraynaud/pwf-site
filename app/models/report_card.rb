class ReportCard < ApplicationRecord
  belongs_to :student_registration
  has_one :student, through: :student_registration
  has_one :season, through: :student_registration
  has_many :grades
  has_one_attached :transcript


  accepts_nested_attributes_for :grades, allow_destroy: true 
  delegate :term, to: :season
  delegate :name, to: :marking_period, prefix: true

  #before_create :set_season_id, :set_student
  after_update :notify, if: :transcript_uploaded

  validates_uniqueness_of :marking_period, scope: [:student_id, :academic_year], message: "Student already has a report card for this marking period and academic year"
  validates :student_registration, :academic_year, :marking_period, presence: true
  scope :current, ->{joins(:season).merge(Season.current_active)}
  scope :with_grades, ->{joins(:grades).select("report_cards.id, report_cards.student_registration_id").uniq}

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

  def term
    student_registration.term
  end

  def reassign_to_last_season
    if student.previous_registration
      self.season_id = Season.previous_season_id 
      self.student_registration_id = student.previous_registration.id
    end
    save
  end


  private

  def notify
    Delayed::Job.enqueue ReportCardUploadedNotificationJob.new(self.id)
  end

  def transcript_uploaded
    changed.include? "transcript"
  end

  def set_student
    self.student_id = student.id
  end

  def set_season_id
    self.season_id = student_registration.season_id if season_id.nil?
  end

end
