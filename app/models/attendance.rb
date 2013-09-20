class Attendance < ActiveRecord::Base
  belongs_to :attendance_sheet
  belongs_to :student_registration, :include => :student
  has_one :student, through: :student_registration

  validates_uniqueness_of :student_registration_id, :scope=>[:session_date, :attendance_sheet_id]

  scope :present, -> {where(attended: true)}
  scope :absent, -> {where(attended:false)}

  def arrival_time_local
     updated_at.localtime
  end

  def late?
    arrival_time_local.hour >= 10
  end
  delegate :name, to: :student, prefix: true
end
