class StudentRegistrationObserver < ActiveRecord::Observer

  def after_create(reg)
    activate_wait_list_if_necessary
  end

  def after_save(reg)
    activate_wait_list_if_necessary
  end


  private

  def current_season
    @season ||= Season.current
  end

  def activate_wait_list_if_necessary
    if current_season.enrollment_limit_reached?
      current_season.wait_list!
      current_season.save
    end
  end

end
