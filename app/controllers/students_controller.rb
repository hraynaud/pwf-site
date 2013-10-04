class StudentsController < InheritedResources::Base

  def new
    redirect_to dashboard_path and return unless current_season.open_enrollment_enabled

    new!{
      @student.student_registrations.build
    }
  end

  def create
    @student = current_parent.students.create(params[:student])
    @student.student_registrations.last.season_id =  current_season.id
    if @student.valid?
      @student.save
      redirect_to  dashboard_path, notice: "Student and registration successfully created"
      return
    else
      render :new
    end
  end


  def show
    show!{ 
      @uploader = @student.avatar
      @uploader.success_action_redirect = avatar_student_url(@student)
      @student_registration = @student.current_registration
    }
  end

  def avatar
    @student = Student.find(params[:id])
    @student.key = params[:key]
    @student.save
    redirect_to student_path(@student)
  end

  def begin_of_association_chain
    current_parent
  end

end
