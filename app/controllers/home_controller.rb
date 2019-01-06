class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_updated_parent_profile
  before_action :redirect_to_profile, :only=>[:index]

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
