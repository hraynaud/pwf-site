class StudentEnrollmentService

 def initialize 

 end

  def open_enrollment
    current_season.open_enrollment_period_is_active?
  end

  def pre_enrollment
    current_season.pre_enrollment_enabled?
  end

  def can_register? student
    (student.registered_last_year? && pre_enrollment) || open_enrollment 
  end  


  def student_registration_helper student
    if !student.currently_registered?
      if (can_register? student) 
        link_to " Register", new_student_registration_path(:student_id=> student.id), :id => "register_student_#{student.id}", :class=> "btn btn-small btn-primary"
      else
        "Registration Opens #{student.registered_last_year? ? current_season.fall_registration_open : current_season.open_enrollment_date}"
      end
    end
  end

end
