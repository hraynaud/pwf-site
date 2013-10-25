class Mgr::ReportCardsController < Mgr::BaseController

  def index
    season_id = params[:season_id].blank? ? Season.current_season_id : params[:season_id]
    @report_cards = ReportCard.where(season_id: season_id)
    @season = Season.find(season_id)
  end

  def new
    new!{
      season_id  = params[:season_id].empty? ? Season.current_season_id : params[:season_id]
      @season = Season.find(season_id)
      @student_registrations = StudentRegistration.where(:season_id => season_id).enrolled.order_by_student_last_name
    } 

  end 

  def edit
    edit!{
      @student_registrations =[@report_card.student_registration]
      @grade_range = GradeRanger.range_by_format_index @report_card.format_cd
      @validations= GradeRanger.validations_by_index_for @report_card.format_cd
    }
  end

end

