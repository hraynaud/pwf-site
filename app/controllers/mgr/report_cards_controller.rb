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

  def show
    @report_card = ReportCard.find(params[:id])
    @uploader = @report_card.transcript
    @uploader.key = key
    @uploader.success_action_redirect = transcript_mgr_report_card_url(@report_card)
  end

  def edit
    edit!{
      @student_registrations =[@report_card.student_registration]
      @grade_range = GradeRanger.range_by_format_index @report_card.format_cd
      @validations= GradeRanger.validations_by_index_for @report_card.format_cd
    }
  end

  def transcript
    @report_card = ReportCard.find(params[:id])
    @report_card.remote_transcript_url = "#{@report_card.transcript.direct_fog_url}#{params[:key]}"
    @report_card.save!

    redirect_to mgr_report_card_path(@report_card)
  end

  def key
    "students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
  end

end

