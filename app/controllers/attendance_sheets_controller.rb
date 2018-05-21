class AttendanceSheetsController < InheritedResources::Base

  def index
    @attendance_sheets= AttendanceSheet.order("session_date desc")
    @total_enrollment = StudentRegistration.current.enrolled.count
  end

  def new
    @attendance_sheet = AttendanceSheet.new(season_id: Season.current_season_id)
  end
  def show
    @attendance_sheet = AttendanceSheet.find(params[:id])
    respond_to do |format|
      format.html

      format.pdf do
        pdf = AttendanceSheetPdf.new(@attendance_sheet.session_date.strftime("%B-%d-%Y"), StudentRegistration.includes(:student, :attendances).current.enrolled)
        disp =params[:disposition].present? ? params[:disposition] : "attachment"
        send_data pdf.render , filename: "attendance#{@attendance_sheet.session_date}.pdf", type: "application/pdf", disposition: disp
      end

    end
  end

  def create
    create!{
      attendances =[]
      StudentRegistration.current.enrolled.each do |reg|
        attendances << @attendance_sheet.attendances.build(:student_registration_id => reg.id, :session_date =>  @attendance_sheet.session_date )
      end
      Attendance.import attendances
      collection_path
    }
  end

  def update
    update!{
      head :no_content
      return
    }
  end

  def edit
    @attendance_sheet = AttendanceSheet.find(params[:id])
  end
  def attendance_sheet_params

  params.require(:attendance_sheet).permit(:session_date, :attendances_attributes, :season_id)
end
