class Mgr::ReportCardsController < Mgr::BaseController
	before_filter :set_season
	before_filter :get_student_registrations
	
	def index
		@report_cards = ReportCard.where(season_id: @season_id)
	end

	def new
   new!{}
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

	def create 
    @report_card = ReportCard.create(params[:report_card])
    if @report_card.valid?
			flash[:notice]="The report card was successfully created you may add grades and/or upload a transcript" 
			redirect_to edit_mgr_report_card_path @report_card
	  else
			flash[:alert]= "There was an error creating this report card"
			@student_registrations =[@report_card.student_registration]
     render :edit
		end
	end

	def transcript
		@report_card = ReportCard.find(params[:id])
		@report_card.remote_transcript_url = "#{@report_card.transcript.direct_fog_url}#{params[:key]}"
		@report_card.save!

		redirect_to mgr_report_card_path(@report_card)
	end

	private

	def key
		"students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
	end

	def get_student_registrations
		@student_registrations = StudentRegistration.where(:season_id => @season_id).enrolled.order_by_student_last_name
	end

	def set_season
		@season_id = params[:season_id].blank? ? Season.current_season_id : params[:season_id]
		@season = Season.find(@season_id)
	end
	
end

