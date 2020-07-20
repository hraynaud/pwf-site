class StudentsController < ApplicationController
  before_action :find_student, only:[:show, :edit, :update]
  helper_method :student_image 

  def index
    @students = current_user.students
  end

  def new
    if StudentRegistrationAuthorizer.new_student_enrollment_forbidden?
      flash[:alert] = "New student enrollment is unavailable at this time"
      redirect_to dashboard_path
    else
      @student = Student.new
      @student.build_current_registration
    end
  end

  def edit
    @student.current_registration_or_new 
  end

  def create
    @student = current_user.students.create(student_params)

    if @student.save
      redirect_to  dashboard_path, notice: "Student and registration successfully created" and return
    else
      flash[:alert] = "Unable to create student. Please fix errors and try again"
      render :new
    end
  end

  def update

    photo = student_params.delete(:photo)
    @student.photo.attach photo if photo
    @student.assign_attributes(student_params)

    if @student.save(student_params)
      render :show
    else
      render :edit
    end
  end

  def show
    @student_registration = @student.current_registration
  end

  def student_params
    params.require(:student)
      .permit(
        :first_name, :last_name, :ethnicity, :gender, 
        :dob, :parent_id, :photo, 
        current_registration_attributes: [
          :school, :grade, :size_cd, :medical_notes, 
          :academic_notes, :academic_assistance, :student_id, :season_id,
          :status_cd
        ])
  end

  private

  def find_student
    @student = current_user.students.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path if @student.nil?
  end
end
