
ActiveAdmin.register AttendanceSheet do
  #form :partial => "form"

  show do
     render 'form'
  end
  member_action :add_students, :method => :get do
    @attendance_sheet = AttendanceSheet.find(params[:id])
    attendances =[]
    regs = StudentRegistration.confirmed
    regs.map do |reg|
      attendances << Attendance.new(:student_registration_id => reg.id, :attendance_sheet_id =>  @attendance_sheet.id )
    end
    Attendance.import attendances
    redirect_to edit_admin_attendance_sheet_path(@attendance_sheet)
  end

  controller do
    def create
      sheet = AttendanceSheet.create(params[:attendance_sheet].except(:attendances))
      redirect_to add_students_admin_attendance_sheet_path(sheet)
      sheet.save
    end

  end


end
