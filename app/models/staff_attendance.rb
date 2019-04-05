class StaffAttendance < ApplicationRecord
  belongs_to :staff
  belongs_to :attendance_sheet
  delegate :name, :current_present_attendances, to: :staff


  scope :ordered, ->{includes(:staff).order("staffs.last_name, staffs.first_name")}
  scope :present, ->{where(attended: true)}
  scope :absent, ->{where(attended: false)}
  scope :current, ->{includes(:attendance_sheet)
    .references(:attendance_sheet)
    .merge(AttendanceSheet.current)
  }

  def self.with_staff
    joins(:staff)
      .merge(Staff.current)
  end 

  def as_json options
    super({methods: [:name], only: [:id, :name, :attended]})
  end

end
