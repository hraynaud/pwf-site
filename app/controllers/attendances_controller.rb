class AttendancesController < InheritedResources::Base
  respond_to :json
  def update
      attendance = Attendance.find(params[:id])
      attendance.update_column(:attended, params[:present]=="checked" ? true : false)
      head :no_content
  end
end
