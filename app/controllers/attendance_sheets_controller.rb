class AttendanceSheetsController < InheritedResources::Base

  def edit
    @attendance_sheet = AttendanceSheet.first
    attendances =[]
    regs = StudentRegistration.enrolled
    regs.each do |reg|
      attendances << Attendance.new(:student_registration_id => reg.id, :attendance_sheet_id =>  @attendance_sheet.id )
    end
    Attendance.import attendances
  end

  def create
    create!{
      collection_path
    }
  end

end
