class StudentRegistrationsController < InheritedResources::Base

  def new
    if params[:student_id]
      @student = Student.find(params[:student_id])
      @student_registration = @student.student_registrations.build
    else
      redirect_to parent_path(current_parent), :notice => "No student found to create registrtion"
    end
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

  def confirmation
      @student_registration = StudentRegistration.find(params[:id])
      @student = @student_registration.student
      render :confirmation, :layout => "receipt"
  end

end
