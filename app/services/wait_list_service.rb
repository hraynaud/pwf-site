class WaitListService

  def self.activate_if_enrollment_limit_reached
    if current_season.enrollment_limit_reached?
      current_season.wait_list!
      current_season.save
    end
  end

  private

  def current_season
    @season ||= Season.current
  end
end
