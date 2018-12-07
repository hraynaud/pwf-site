class ReportCardsController < ApplicationController
  after_action :notify_transcript_uploaded, only:[:update, :create], if: :transcript_changed?
  before_action :load_student_registrations, only:[:new, :create]
  before_action :load_current, only: [:show, :edit, :update]

  rescue_from FileUploadToPdf::IncompatibleFileTypeForMergeError, with: :add_incompatible_file_type_error

  def index
    @report_cards = current_user.report_cards
  end

  def new
    @report_card = ReportCard.new
  end

  def create
    @report_card = ReportCard.new(report_card_params)
    attach_pages_if_present

    if @report_card.save
      redirect_to report_cards_path
    else
      flash[:alert]="Unable to create report card. Please fix errors and tya again"
      render :new
    end
  end

  def update
    if @report_card.update_attributes(report_card_params)
      attach_pages_if_present
      redirect_to report_cards_path
    else
      flash[:alert]="Unable to update report card. Please fix errors and tya again"
      render :edit
    end
  end

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

  def attach_pages_if_present
    if pages.present?
      pdf = FileUploadToPdf.combine_uploaded_files pages

      @report_card.transcript.attach(io: pdf, filename: "#{@report_card.description}.pdf", content_type: "application/pdf")
      @transcript_changed = true
    end
  end

  def transcript_changed?
    @transcript_changed
  end

  def transcript
    @transcript ||= params[:report_card][:transcript]
  end

  def pages
    @pages ||= params[:report_card][:transcript_pages]
  end

  def notify_transcript_uploaded
    ReportCardMailer.uploaded(@report_card).deliver_later if @report_card.valid?
  end

  def report_card_params
    params.require(:report_card).permit(:student_registration_id, :season_id, :academic_year, :marking_period, :format_cd, :grades_attributes)
  end

end
