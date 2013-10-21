class Mgr::AepAttendancesController < Mgr::BaseController
	def index
		sheet = AttendanceSheet.find(params[:attendance_sheet_id])
		respond_to do|format|
			format.html
			format.json{
				render json: [sheet.current_students, Group.group_list]
			}
		end
	end

	def update
		attendance = Attendance.find(params[:id])
		attendance.update_column(:attended, params[:attended])
		head :no_content
	end
	
end
