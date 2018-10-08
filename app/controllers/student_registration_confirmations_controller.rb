class StudentRegistrationConfirmationsController < ApplicationController
  layout: "receipt"

  def show 
    @student_registration = current_parent.student_registrations.find(params[:registration_id])
    @student = @student_registration.student
    @payment = @student_registration.payment
  end
end
