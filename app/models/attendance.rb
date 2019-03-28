class Attendance < ApplicationRecord
  belongs_to :attendance_sheet
  belongs_to :student_registration, ->{includes :student}
  has_one :student,  through: :student_registration
  has_one :group, through: :student_registration

  validates_uniqueness_of :student_registration_id, :scope => [:session_date, :attendance_sheet_id]

  scope :present, -> {where(attended: true)}
  scope :absent, -> {where(attended:false)}
  scope :ordered, ->{order("students.last_name, students.first_name")}
  scope :by_attendance_sheet, ->(id){with_students.where(attendance_sheet_id: id)}

  delegate :name, :first_name, :last_name, to: :student
  delegate :current_attendances, to: :student

  def self.current
    self.joins(:student_registration).merge(StudentRegistration.current)
  end

  def self.with_student
    self.joins(:student_registration =>:student)
      .merge(StudentRegistration.confirmed)
      .preload(:student).select("student_registration_id, attended, attendances.id, students.first_name, students.last_name")
  end 

  def arrival_time_local
     updated_at.localtime
  end

  def thumbnail

    photo_url = student.photo.attached? ? student.photo.variant(resize: "64x64") : nil
    photo_url ?  Rails.application.routes.url_helpers.rails_representation_url(photo_url, only_path: true) : nil
  end

  def group_id
     return group.try(:id).nil? ? -1 : group.id
  end

  def late?
    arrival_time_local.hour >= 10
  end

  def as_json options
    super({methods: [:name, :thumbnail], only: [:id, :name, :attended]})
  end
end
