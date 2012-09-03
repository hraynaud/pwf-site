
ActiveAdmin.register AttendanceSheet do
  form :partial => "form"
  # form do |f|
    # f.inputs  do
      # f.input :session_date, :end_year => Time.now.year+1, :start_year => Time.now.year-1, :include_blank => true
    # end
    # f.inputs :for => :attendances do |s|
      # if s.object.student_registration
        # label = s.object.student_registration.student_name
        # s.input :attended, :label => label,  :input_html =>{:type => "checkbox" }
        # s.input :student_registration_id, :as => :hidden
      # end
    # end
    # f.buttons :commit
  # end

  member_action :add_students, :method => :get do
    @attendance_sheet = AttendanceSheet.find(params[:id])
    attendances =[]
    regs = StudentRegistration.current
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

    def new
      attendances = []
      @attendance_sheet = AttendanceSheet.new
    end

    def edit
      @attendance_sheet = AttendanceSheet.find(params[:id])
    end



      end


end
