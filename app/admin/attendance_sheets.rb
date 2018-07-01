ActiveAdmin.register AttendanceSheet do

  permit_params :session_date,:season_id
  controller do
    def create
      sheet = AttendanceSheet.create(permitted_params[:attendance_sheet])
      sheet.generate_attendances
      redirect_to admin_attendance_sheet_path(sheet)
    end

    def show
      @attendance_sheet = AttendanceSheet.find(params[:id])
       respond_to do |format|
        format.html
        format.json { render json: @attendance_sheet.attendances.ordered }
       end
    end
  end

  show :title => proc {"Attendance For: #{@attendance_sheet.session_date}"}do
    render "sign_in_sheet"
  end

end
