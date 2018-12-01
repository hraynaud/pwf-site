class StudentsController < ApplicationController
  before_action :find_student, only:[:show, :edit, :update]
  helper_method :student_image 

  def index
    @students = current_user.students
  end

  def new
    redirect_to dashboard_path and return unless current_season.open_enrollment_period_is_active?
    @student = Student.new
    @student.student_registrations.build
  end

  def edit
    @student.current_registration_or_new
  end

  def create
    @student = current_user.students.create(student_params)

    if @student.save
      redirect_to  dashboard_path, notice: "Student and registration successfully created" and return
    else
      render :new
    end
  end

  def update

    photo = student_params.delete(:photo)
    @student.photo.attach photo if photo

    if @student.update_attributes(student_params)
      render :show
    else
      render :edit
    end
  end

  def show
    @student_registration = @student.current_registration
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :ethnicity, :gender, :dob, :parent_id, :photo, student_registrations_attributes:[:school, :grade, :size_cd, :medical_notes, 
    :academic_notes, :academic_assistance, :student_id, :season_id, 
    :status_cd, :first_report_card_received, :first_report_card_expected_date, 
    :first_report_card_received_date, :second_report_card_received, 
    :second_report_card_expected_date, :second_report_card_received_date,
    :report_card_exempt] )
  end

  private

  def find_student
    @student = current_user.students.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path if @student.nil?
  end
end
