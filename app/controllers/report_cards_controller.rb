class ReportCardsController < ApplicationController
  before_action :require_parent_user
  before_action :require_student_registration, only: [:new]

  def index
    @report_cards = current_parent.report_cards
  end

  def new
    @student_registrations =current_parent.student_registrations.current
    @report_card = ReportCard.new
    @grade_range =  GradeRanger.default_grade_range 
    @validations= GradeRanger.default_validations
    params[:student_id] ? @selected = @student_registrations.find_by_student_id( params[:student_id]).id : nil 
  end

  def show
    @report_card = current_parent.report_cards.find(params[:id])
    @uploader = @report_card.transcript
  end

  def create
    @report_card = ReportCard.create(report_card_params)
    @student_registrations =current_parent.student_registrations.current
    if @report_card.valid?
      flash[:notice]="Report card template created. Please upload a hard copy to complete"
      redirect_to edit_report_card_path(@report_card)
    else
      flash[:error]="Some errors were detected please try again"
      render :edit
    end
  end

  def edit
      @report_card = ReportCard.find(params[:id])
      @student_registrations =[@report_card.student_registration]
  end

  def update
    @report_card = current_parent.report_cards.find(params[:id])
    @student_registrations =[@report_card.student_registration]
    @report_card.attributes = report_card_params
    if @report_card.valid?
      @report_card.save
      redirect_to report_card_path(@report_card)
    else
      render :edit
    end
  end

  def transcript
    @report_card = current_parent.report_cards.find(params[:id])
    @report_card.remote_transcript_url = "#{@report_card.transcript.direct_fog_url}#{params[:key]}"
    @report_card.save!
    flash[:notice]="Report card successfully uploaded"
    redirect_to edit_report_card_path(@report_card)
  end

  def require_student_registration
    @student_registrations = current_parent.student_registrations.current
    redirect_to dashboard_path if @student_registrations.empty?
  end

  def key
    "students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
  end

  def report_card_params

    params.require(:report_card).permit(:student_registration_id, :season_id, :academic_year, :marking_period, :format_cd, :transcript, :grades_attributes)
  end


end
