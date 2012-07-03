class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_parent!
  before_filter :check_season

  helper_method :current_season

  def current_season
    @season ||= Season.current
  end

  def after_sign_in_path_for(resource)
    parent_path(resource)
  end

  def check_season
    if Season.current.nil?
    redirect_to registration_closed_path
    end
  end

end
