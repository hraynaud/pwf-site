class Mgr::ReportCardsController < Mgr::BaseController

  def new 
    if params[:season_id].blank?
      flash[:error]="Please select a season"
      redirect_to collection_path
    else
      @term = Season.find(params[:season_id]).term
      @student_registrations = StudentRegistration.by_season(params[:season_id]).enrolled
      new!{

      }
    end
  end

end

