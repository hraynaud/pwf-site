class AttendancesController < InheritedResources::Base

  respond_to :json

  def index
    sheet = AttendanceSheet.find(params[:attendance_sheet_id])
    respond_to do|format|
      format.html
      format.json{
        render json: [sheet.current_students, Group.group_list, sheet.session_date]
      }
    end
  end



  def update
    attendance = Attendance.find(params[:id])
    attendance.update_column(:attended, params[:attended])
    head :no_content
  end
end
