class AttendanceSheetsController < InheritedResources::Base

  def index
    @attendance_sheets= AttendanceSheet.order("session_date desc")
    @total_enrollment = StudentRegistration.current.enrolled.count
  end

  def new
     @attendance_sheet = AttendanceSheet.new(season_id: Season.current_season_id)
  end

  def create
    create!{
      attendances =[]
      StudentRegistration.current.enrolled.each do |reg|
        attendances << Attendance.new(:student_registration_id => reg.id, :attendance_sheet_id =>  @attendance_sheet.id )
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

end
