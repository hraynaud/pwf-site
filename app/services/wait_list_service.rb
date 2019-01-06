class WaitListService

  def self.activate_if_enrollment_limit_reached
    @season = Season.current

    if @season.enrollment_limit_reached?
      @season.wait_list!
      @season.save
    end
  end

end
