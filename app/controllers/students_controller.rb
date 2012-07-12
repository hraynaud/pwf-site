class StudentsController < InheritedResources::Base
  def new
    new!{
      @student.student_registrations.build
    }
  end
  def create
    @student = current_parent.students.create(params[:student])
    @student.student_registrations.last.season_id =  current_season.id
    @student.save
    if @student.valid?
      redirect_to parent_path(current_parent)
      return
    else
      render :new
    end
  end

  def show
      show!{ @student_registration = @student.current_registration}
  end

  def begin_of_association_chain
    @current_parent = current_parent
    @current_parent
  end

end
