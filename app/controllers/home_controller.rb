class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_to_profile, :only=>[:index]
  #skip_before_action :check_season, :only=>[:closed ]

  def index
  end

  def closed
  end

  private
  def redirect_to_profile
    redirect_to dashboard_path if user_signed_in?
  end

end
