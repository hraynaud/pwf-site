class AttendanceSheetsController < InheritedResources::Base

  def show

    @attendance_sheet = AttendanceSheet.first
    attendances =[]
    regs = StudentRegistration.enrolled
    regs.each do |reg|
      attendances << Attendance.new(:student_registration_id => reg.id, :attendance_sheet_id =>  @attendance_sheet.id )
    end
    Attendance.import attendances
    #redirect_to edit_admin_attendance_sheet_path(@attendance_sheet)

  end

end
