class StudentRegistrationAuthorizer
  class << self
    def can_register? student
      allowed_to_register_during_period? student
    end

    private
    def open_enrollment_active?
      current_season.open_enrollment_period_is_active?
    end

    def returning_student_enrollment_active?
      current_season.pre_enrollment_enabled?
    end


    def allowed_to_register_during_period? student
      (student.registered_last_year? && returning_student_enrollment_active?) || open_enrollment_active?
    end

  end
end
