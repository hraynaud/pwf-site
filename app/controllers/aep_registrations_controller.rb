class AepRegistrationsController < InheritedResources::Base
  def new
    student = current_parent.student_by_id(params[:student_id])
    @student_registration_id = student.current_registration.id
    @aep_registration = AepRegistration.new
    @student_name = student.name
  end


  def edit
    edit! do 
      @student_name = @aep_registration.student_name
      @student_registration_id = @aep_registration.student.current_registration.id
    end
  end

end
