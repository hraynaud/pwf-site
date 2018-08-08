class StudentsController < ApplicationController
  before_action :find_student, only:[:show, :edit, :update]

  def new
    redirect_to dashboard_path and return unless current_season.open_enrollment_enabled
    @student = Student.new
    @student.student_registrations.build
  end

  def edit
    @student.current_registration_or_new
  end

  def create
    @student = current_parent.students.create(student_params)
    if @student.valid?
      @student.save
      redirect_to  dashboard_path, notice: "Student and registration successfully created" and return
    else
      render :new
    end
  end

  def update
    @student.update_attributes(student_params)
    render :show
  end

  def show
    @student_registration = @student.current_registration
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :ethnicity, :gender, :dob, :parent_id, student_registrations_attributes:[:school, :grade, :size_cd, :medical_notes, 
    :academic_notes, :academic_assistance, :student_id, :season_id, 
    :status_cd, :first_report_card_received, :first_report_card_expected_date, 
    :first_report_card_received_date, :second_report_card_received, 
    :second_report_card_expected_date, :second_report_card_received_date,
    :report_card_exempt] )
  end

  def key
    "students/profile_pictures/#{@student.name.parameterize}-#{@student.id}/\${filename}"
  end

  private

  def find_student
    @student = Student.find(params[:id])
  end
end
