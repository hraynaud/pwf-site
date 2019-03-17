class StaffAttendanceSheet < ApplicationRecord
  belongs_to :attendance_sheet
  belongs_to :season
  has_many :staff_attendances

  after_create :create_staff_attendances

  private

  def create_staff_attendances
    Season.current.staffs.each do |staff|
      staff.staff_attendances.create(attended: false)
    end
  end

end
