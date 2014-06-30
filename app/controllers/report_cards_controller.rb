class ReportCardsController < InheritedResources::Base
  before_filter :require_parent_user

  def index
    @report_cards = current_parent.report_cards
  end

  def new
    @student_registrations =current_parent.student_registrations.current
    @report_card = ReportCard.new
    @grade_range =  GradeRanger.default_grade_range 
    @validations= GradeRanger.default_validations
  end

  def show
    @report_card = current_parent.report_cards.find(params[:id])
    @uploader = @report_card.transcript
    @uploader.key = key
    @uploader.success_action_redirect = transcript_report_card_url(@report_card)
  end

  def create
    @report_card = ReportCard.create(params[:report_card])
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
    edit!{
      @student_registrations =[@report_card.student_registration]
      @grade_range = GradeRanger.range_by_format_index @report_card.format_cd
      @validations= GradeRanger.validations_by_index_for @report_card.format_cd
      @uploader = @report_card.transcript
      @uploader.key = key
      @uploader.success_action_redirect = transcript_report_card_url(@report_card)
    }
  end

  def update
    @report_card = current_parent.report_cards.find(params[:id])
    @student_registrations =[@report_card.student_registration]
    @report_card.attributes = params[:report_card]
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

  def key
    "students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
  end


end
