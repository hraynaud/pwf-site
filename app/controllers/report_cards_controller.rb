class ReportCardsController < ApplicationController
  before_action :load_student_registrations, only:[:new, :create]
  before_action :load_current, only: [:show, :edit, :update]


  def index
    @report_cards = current_user.report_cards
  end

  def new
    if params[:student_id].present?
      s = Student.find(params[:student_id])
      reg = s.student_registrations.last_confirmed

      if(reg)
        @report_card = reg.report_cards.build
        return
      end
    end

    redirect_to report_cards_path, alert: "You can can only upload report cards
    for students that are currently or have previously attended the PWF"
  end

  def create
    @report_card = ReportCard.new(report_card_params)
    if @report_card.save
      ReportCardMailer.uploaded(@report_card).deliver_later #always deliver since transcript is required on create
      ReportCardMailer.confirmation(@report_card, current_user).deliver_later 
      redirect_to report_cards_path
    else
      flash[:alert]="Unable to create report card"
      render :new
    end
  end

  def update
    if @report_card.update_attributes(report_card_params)
      ReportCardMailer.uploaded(@report_card).deliver_later if @report_card.transcript_modified?
      redirect_to report_cards_path
    else
      flash[:alert]="Unable to update report card"
      render :edit
    end
  end

  #TODO handle redirect after delete more elegantly
  def destroy
    @report_card = ReportCard.find(params[:id])
    @report_card.destroy
    redirect_to report_cards_path
  end

  private


  def add_incompatible_file_type_error
    @report_card.errors.add(:base, "All files must be of the same file type")
    render @report_card.new_record? ? :new : :edit
  end

  def load_current
    @report_card = ReportCard.find(params[:id])
    @student_registrations =[@report_card.student_registration]
  end

  def load_student_registrations
    @student_registrations = current_user.student_registrations.current
  end

  def transcript_modified?
    @report_card.transcript_modified?
  end

  def pages
    @pages ||= params[:report_card][:transcript_pages]
  end

  def notify_transcript_uploaded
    ReportCardMailer.uploaded(@report_card).deliver_later if @report_card.transcript_modified?
  end

  def report_card_params
    params.require(:report_card).permit(:student_registration_id, :season_id, :academic_year, :marking_period_id, :format_cd, {transcript_pages:[]}, :grades_attributes )
  end

end
