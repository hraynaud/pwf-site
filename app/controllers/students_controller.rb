class StudentsController  < ApplicationController
	respond_to :html

  before_filter :get_student, only: [:show, :edit, :update, :destroy]
  def new
    redirect_to dashboard_path and return unless current_season.open_enrollment_enabled
		@student = current_parent.students.build
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

	def update
     if @student.update_attributes(params[:student])
			 flash[:notice] = "Student Successfully updated"
		 else 
			 flash[:error] = "Student not save"
		 end
		 respond_with @student
	end


  def show
      @uploader = @student.avatar
      @uploader.success_action_redirect = avatar_student_url(@student)
      @student_registration = @student.current_registration
  end

  def avatar
    @student = Student.find(params[:id])
    @student.remote_avatar_url = "#{@student.avatar.direct_fog_url}#{params[:key]}" 
      @student.save
    redirect_to student_path(@student)
  end

  def get_student
		@student = current_parent.students.find(params[:id])
  end


  def key
    "students/profile_pictures/#{@student.name.parameterize}-#{@student.id}/\${filename}"
  end
end
