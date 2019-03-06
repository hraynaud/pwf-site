class WaitListService
  class << self
    def activate_if_enrollment_limit_reached
      @season = Season.current

      if @season.enrollment_limit_reached?
        @season.wait_list!
        @season.save
      end
    end

    def historical_waitlist
      StudentRegistration
        .wait_listed.joins(:student)
        .where.not(student_id: StudentRegistration.current.confirmed.pluck(:student_id))
    end
  end 
end
