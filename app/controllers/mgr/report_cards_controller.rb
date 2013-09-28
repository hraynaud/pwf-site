class Mgr::ReportCardsController < Mgr::BaseController


  def new 
    if params[:season_id].blank?
      flash[:error]="Please select a season"
      redirect_to collection_path
    else
      new!{
        @term = Season.find(params[:season_id]).term
        @student_registrations = StudentRegistration.by_season(params[:season_id]).enrolled
      }
    end
  end

  def edit
    edit!{
      @student_registrations =[@report_card.student_registration]
      @grade_range = GradeRanger.range_by_format_index @report_card.format_cd
      @validations= GradeRanger.validations_by_index_for @report_card.format_cd
    }
  end

end

