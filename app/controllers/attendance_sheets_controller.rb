class AttendanceSheetsController < InheritedResources::Base

  def index
    @attendance_sheets= AttendanceSheet.order("session_date desc")
    @total_enrollment = StudentRegistration.current.confirmed.count
  end

  def new
    @attendance_sheet = AttendanceSheet.new(season_id: Season.current_season_id)
  end

  def show
    @attendance_sheet = AttendanceSheet.find(params[:id])
    respond_to do |format|
      format.html

      format.pdf do
        pdf = AttendanceSheetPdf.new(@attendance_sheet.session_date.strftime("%B-%d-%Y"), StudentRegistration.includes(:student, :attendances).current.confirmed)
        disp =params[:disposition].present? ? params[:disposition] : "attachment"
        send_data pdf.render , filename: "attendance#{@attendance_sheet.session_date}.pdf", type: "application/pdf", disposition: disp
      end

    end
  end

  def create
    create!{
      @attendance_sheet.generate_attendances
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
