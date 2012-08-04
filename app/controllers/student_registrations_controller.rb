class StudentRegistrationsController < ApplicationController

  def new
    if params[:student_id]
      @student = Student.find(params[:student_id])
      @student_registration = @student.student_registrations.build
    else
      redirect_to parent_path(current_parent), :notice => "No student found to create registrtion"
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
      redirect_to parent_path(current_parent)
      return
    else
      render :new
    end
  end

  def destroy
    registration = current_parent.student_registrations.find(params[:id])
    registration.destroy
    redirect_to parent_root_path(current_parent)
  end

  def confirmation
      @student_registration = current_parent.student_registrations.find(params[:id])
      @student = @student_registration.student
      @payment = @student_registration.payment
      render :confirmation, :layout => "receipt"
  end

  protected
  def begin_of_association_chain
    current_parent
  end

end
