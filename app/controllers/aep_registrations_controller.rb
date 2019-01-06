class AepRegistrationsController < ApplicationController
  before_action :load_aep_registration, except:[:new, :create]
  def new
    student_registration = StudentRegistration.find(params[:student_registration_id])
    @aep_registration = student_registration.build_aep_registration
  end


  def create
    @aep_registration = AepRegistration.new(aep_registration_params)
    if @aep_registration.save
     redirect_to dashboard_path
    else
      render :new
    end
  end

  def update 
    @student_name = @aep_registration.student_name
    @student_registration_id = @aep_registration.student.current_registration.id
    @aep_registration
  end

  private

  def load_aep_registration
    @aep_registration = AepRegistration.find(params[:id])
  end

  def aep_registration_params
    params.require(:aep_registration).permit(:learning_disability,:learning_disability_details,:iep,:iep_details, :student_registration_id)
  end

end
