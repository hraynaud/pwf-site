class ReportCardsController < InheritedResources::Base
  before_filter :require_parent_user

  def index
    @report_cards = current_parent.report_cards
  end

  def new
    @student_registrations =current_parent.student_registrations.current
    @report_card = ReportCard.new
  end

  def show
    @report_card = current_parent.report_cards.find(params[:id])
    @uploader = @report_card.transcript
    @uploader.key = key
    @uploader.success_action_redirect = transcript_report_card_url(@report_card)
  end
  def edit
    edit!{
      @student_registrations =[@report_card.student_registration]
    }
  end

  def update
    @report_card = current_parent.report_cards.find(params[:id])
    @report_card.update_attributes(params[:report_card])
    redirect_to report_card_path(@report_card)
  end

  def transcript
    @report_card = current_parent.report_cards.find(params[:id])
    @report_card.remote_transcript_url = "#{@report_card.transcript.direct_fog_url}#{params[:key]}"
    @report_card.save!

    redirect_to @report_card
  end

  def key
    "students/report_cards/#{@report_card.student_name.parameterize}-#{@report_card.student.id}/\${filename}"
  end


end
