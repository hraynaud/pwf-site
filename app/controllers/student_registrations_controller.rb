class StudentRegistrationsController < ApplicationController
  before_action :get_registration, only:[:show, :edit, :destroy, :update, :withdraw]

  def new
    if params[:student_id]

      @student = current_user.students.find(params[:student_id])
      resp = StudentRegistrationAuthorizer.can_register? @student
      if resp.answer == false
        redirect_to @student, error: resp.message
      end
      @student_registration = @student.student_registrations.build
    else
      redirect_to dashboard_path, :notice => "No student found to create registration"
    end
  end

  def edit

  end

  def withdraw

  end

  def create
    @student_registration = StudentRegistration.new(student_registration_params)

    if @student_registration.save
      StudentRegistrationMailer.notify(@student_registration).deliver_later
      WaitListService.activate_if_enrollment_limit_reached
      redirect_to dashboard_path, notice: "Student registration successfully created"
    else
      render :new
    end
  end

  def destroy
    @student_registration.destroy
    redirect_to dashboard_path
  end

  def update
    if  @student_registration.update_attributes(student_registration_params)
      if request.xhr?
        head :ok;
      else
        redirect_to dashboard_path and return
      end
    else
      render :edit
    end
  end

  private

  def get_registration
    @student_registration = current_user.student_registrations.find(params[:id])
      rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path if @student_registration.nil?
  end

  def student_registration_params
    params.require(:student_registration).permit(
  :school, :grade, :size_cd, :medical_notes, 
    :academic_notes, :academic_assistance, :student_id, :season_id, 
    :status_cd)
  end

end
