class ReportCardsController < ApplicationController
	respond_to :html

  before_filter :require_parent_user
  before_filter :get_student_registration
  before_filter :get_report_card, only: [:edit, :update, :destroy, :transcript]
 
  def index
    @report_cards = current_parent.report_cards
  end

  def new
    # @student_registrations =current_parent.student_registrations.current
    @report_card = ReportCard.new
    @grade_range =  GradeRanger.default_grade_range 
    @validations= GradeRanger.default_validations
		@student_registration = current_parent.student_registrations.find( params[:student_registration_id])
    # params[:student_id] ? @selected = @student_registrations.find_by_student_id( params[:student_id]).id : nil 
  end

  def show
    @report_card = current_parent.report_cards.find(params[:id])
    @uploader = @report_card.transcript
    @uploader.key = key
    @uploader.success_action_redirect = transcript_report_card_url(@report_card)
  end

  def create
		@report_card = @student_registration.report_cards.create(params[:report_card])
    if @report_card.valid?
      flash[:notice]="Report card template created. Please upload a hard copy to complete"
    else
      flash[:error]="Some errors were detected please try again"
    end
		respond_with @student_registration, @report_card
  end


  def edit
      @uploader = @report_card.transcript
      @uploader.key = key
      @uploader.success_action_redirect = transcript_report_card_url(@report_card)
  end

  def update
    @report_card.attributes = params[:report_card]
    if @report_card.save?
			flash[:notice]="Feport card saved"
    else
			flash[:error]="Error saving report card"
    end
  end

  def transcript
    @report_card.remote_transcript_url = "#{@report_card.transcript.direct_fog_url}#{params[:key]}"
    @report_card.save!
    flash[:notice]="Report card successfully uploaded"
    redirect_to edit_report_card_path(@report_card)
  end

 private

  def key
    "students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
  end


 def get_student_registration
		@student_registration = current_parent.student_registrations.find( params[:student_registration_id])
 end 

 def get_report_card
	 @report_card =  @student_registration.report_cards.find(params[:id])
 end 

end
