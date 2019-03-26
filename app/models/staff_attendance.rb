class StaffAttendance < ApplicationRecord
  belongs_to :staff

  belongs_to :attendance_sheet
  delegate :name, to: :staff

  scope :ordered, ->{includes(:staff).order("staffs.last_name, staffs.first_name")}

  def self.with_staff
    joins(:staff)
      .merge(Staff.current)
  end 

  def as_json options
    super({methods: [:name], only: [:id, :name, :attended]})
  end
end
