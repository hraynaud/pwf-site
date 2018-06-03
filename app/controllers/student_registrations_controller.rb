class StudentRegistrationsController < ApplicationController
  before_action :check_season, only: [:new, :create]
 
  include ApplicationHelper
  def new
    if params[:student_id]
      @student = current_parent.students.find(params[:student_id])
      redirect_to @student and return unless can_register? @student
      @student_registration = @student.student_registrations.build
    else
      redirect_to dashboard_path, :notice => "No student found to create registration"
      
    end
  end

  def show
    @student_registration = current_parent.student_registrations.find(params[:id])
  end


  def create
    @student_registration = StudentRegistration.new(params[:student_registration])
    @student_registration.season = current_season
    if @student_registration.valid?
      @student_registration.save!
      redirect_to  dashboard_path, notice: "Student registration successfully created"
      return
    else
      render :new
    end
  end

  def destroy
    registration = current_parent.student_registrations.find(params[:id])
    registration.destroy
    redirect_to dashboard_path
  end

  def confirmation
    @student_registration = current_parent.student_registrations.find(params[:id])
    @student = @student_registration.student
    @payment = @student_registration.payment
    render :confirmation, :layout => "receipt"
  end

   
  def update
 
    respond_to do |format|
      format.json{
        stud_reg = StudentRegistration.find(params[:id])
        stud_reg.update_column(:group_id, params[:groupId])
        head :no_content
      }
    end
  end
   
  def grouping
   StudentRegistration.current.confirmed
  end


  protected
  def begin_of_association_chain
    current_parent
  end

  def student_registration_params
    params.require(:student_registration).permit(
  :school, :grade, :size_cd, :medical_notes, 
    :academic_notes, :academic_assistance, :student_id, :season_id, 
    :status_cd, :first_report_card_received, :first_report_card_expected_date, 
    :first_report_card_received_date, :second_report_card_received, 
    :second_report_card_expected_date, :second_report_card_received_date,
    :report_card_exempt)
  end

end
