class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :redirect_to_profile, :only=>[:index]
  skip_before_filter :check_season, :only=>[:closed ]

  def index
    if Season.current.status == "Closed" and Season.next
      @curr = Season.next
      @prev = Season.current
    else
      @curr = Season.current
      @prev = Season.previous
    end
  end

  def closed
  end

  private
  def redirect_to_profile
    redirect_to dashboard_path if user_signed_in?
  end

end
