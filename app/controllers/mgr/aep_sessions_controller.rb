class Mgr::AepSessionsController < Mgr::BaseController

  def index
    @aep_sessions= AepSession.order("session_date desc")
    @total_paid = AepRegistration.current.paid.count
  end

  def new
    @aep_session = AepSession.new(season_id: Season.current_season_id)
  end

  def create
    create!{
      attendances =[]
      AepRegistration.current.paid.each do |reg|
        attendances << AepAttendance.new(:aep_registration_id => reg.id, :aep_session_id =>  @aep_session.id )
      end
      AepAttendance.import attendances
      collection_path
    }
  end

  def edit
    @aep_session = AepSession.find(params[:id])
  end
end
