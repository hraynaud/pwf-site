class StudentRegistrationsController < InheritedResources::Base
  def new
    new!{@student_registration.build_student}
  end
  def create
    create!{
      @student_registration.season = current_season
      @student_registration.parent = current_parent
      @student_registration.student.parent = current_parent
      if @student_registration.valid?
        @student_registration.save!
        redirect_to parent_path(current_parent)
        return
      end
    }
  end

  def begin_of_association_chain
     @current_parent = current_parent
    @current_parent
  end

end
