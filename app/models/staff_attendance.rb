class StaffAttendance < ApplicationRecord
  belongs_to :staff
  belongs_to :staff_attendance_sheet


  delegate :name, to: :staff

 def as_json options
    super({methods: [:name], only: [:id, :name, :attended]})
  end
end
