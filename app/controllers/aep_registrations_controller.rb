class AepRegistrationsController < InheritedResources::Base
  def new
    student = current_user.student_by_id(params[:student_id])
    @student_registration_id = student.current_registration.id
    @aep_registration = student.aep_registrations.build 
    @student_name = student.name
  end

  def show
    show!{
        @workshops = @aep_registration.workshops
     }
  end

  def edit
    edit! do 
      @student_name = @aep_registration.student_name
      @student_registration_id = @aep_registration.student.current_registration.id
    end
  end


  def create
    create!{
      @student_registration_id = @aep_registration.student.current_registration.id
      @aep_registration
    }
  end

  def update 
    update! do 
      @student_name = @aep_registration.student_name
      @student_registration_id = @aep_registration.student.current_registration.id
      @aep_registration
    end
  end

  protected 

  #def end_of_association_chain
  #current_user
  #end
end
