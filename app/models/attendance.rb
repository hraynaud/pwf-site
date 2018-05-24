class Attendance < ActiveRecord::Base
  belongs_to :attendance_sheet
  belongs_to :student_registration, ->{includes  :student}
  has_one :student, through: :student_registration
  has_one :group, through: :student_registration

  validates_uniqueness_of :student_registration_id, :scope=>[:session_date, :attendance_sheet_id]

  scope :present, -> {where(attended: true)}
  scope :absent, -> {where(attended:false)}
  scope :current, -> {joins(:student_registration).merge StudentRegistration.current.enrolled}

  def arrival_time_local
     updated_at.localtime
  end
 
  def group_id
     return group.try(:id).nil? ? -1 : group.id
  end

  def late?
    arrival_time_local.hour >= 10
  end
  delegate :name, to: :student, prefix: true
end
