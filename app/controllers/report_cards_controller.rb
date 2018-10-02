class ReportCardsController < ApplicationController
  after_action :notify_transcript_uploaded, only:[:update, :create], if: :transcript_changed?
  before_action :load_student_registrations, only:[:new, :create]
  before_action :load_current, only: [:show, :edit, :update]

  def index
    @report_cards = current_parent.report_cards
  end

  def new
    @report_card = ReportCard.new
  end

  def create
    @report_card = ReportCard.new(report_card_params)
    attach_transcript_if_present

    if @report_card.save
      redirect_to report_cards_path
    else
      render :new
    end
  end

  def update
    @report_card.attributes = report_card_params

    if @report_card.valid?
      attach_transcript_if_present
      @report_card.save
      redirect_to report_cards_path
    else
      render :edit
    end
  end

  def destroy
    @report_card = ReportCard.find(params[:id])
    @report_card.destroy
    redirect_to report_cards_path
  end

  private

  def load_current
    @report_card = ReportCard.find(params[:id])
    @student_registrations =[@report_card.student_registration]
  end

  def load_student_registrations
    @student_registrations = current_parent.student_registrations.current
  end

  def attach_transcript_if_present
    if transcript.present?
      @report_card.transcript.attach(transcript)
      @transcript_changed = true
    end
  end

  def transcript_changed?
    @transcript_changed
  end

  def transcript
    @transcript ||= params[:report_card][:transcript]
  end

  def notify_transcript_uploaded
    ReportCardMailer.uploaded(@report_card).deliver_later
  end

  def report_card_params
    params.require(:report_card).permit(:student_registration_id, :season_id, :academic_year, :marking_period, :format_cd, :grades_attributes)
  end

end
