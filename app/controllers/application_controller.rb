class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_season

  def current_season
    @season ||=Season.where(:current => true).first
  end

end
