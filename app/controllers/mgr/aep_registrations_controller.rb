class Mgr::AepRegistrationsController < Mgr::BaseController
  def index
    season_id = params[:season_id].blank? ? Season.current_season_id : params[:season_id]
    @season = Season.find(season_id)
    @aep_registrations = AepRegistration.where(season_id: season_id)
  end

  def show
    show!{
      @workshops = @aep_registration.workshops
    }
  end

  def edit
    edit!{
      @student_registrations =[@aep_registration.student_registration]
    }
  end

  def new
    new!{
      season_id  = params[:season_id].empty? ? Season.current_season_id : params[:season_id]
      @season = Season.find(season_id)
      @student_registrations = StudentRegistration.where(:season_id => season_id).enrolled.order_by_student_last_name
    }
  end

end
