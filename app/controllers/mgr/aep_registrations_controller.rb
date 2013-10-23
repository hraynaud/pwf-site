class Mgr::AepRegistrationsController < Mgr::BaseController

  def show
    show!{
      @workshops = @aep_registration.workshops
    }
  end
  
  def new
  	new!{
  		season_id  = params[:season_id].empty? ? Season.current_season_id : params[:season_id]
  		@season = Season.find(season_id)
  		@student_registrations = StudentRegistration.where(:season_id => season_id).paid
  	} 

  end 


end
