class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_parent!
  before_filter :check_season, :unless => Proc.new { |c| c.devise_controller? || c.kind_of?(ActiveAdmin::ResourceController) }
  helper_method :current_season
  def current_season
    @season ||= Season.current
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Parent)
      if resource_or_scope.all_valid?
        parent_path(resource_or_scope)
      else
        #NOTE The parent information is invalid redirect to the edit page
        #TODO determine if parent should be validated after every action?
        flash[:alert]="You profile information is invalid:"
        #TODO figure out better way to get around the default rails behavior which validates the resource somehow on the call to respond_with/respond_to.
        #,fThis forces the path to be set back to the sign in path even though the user is signed in.
        edit_parent_path(resource_or_scope)
      end
    elsif resource_or_scope.is_a?(AdminUser)
      admin_dashboard_path
    end
  end

  def check_season
    if Season.current.nil?
       redirect_to registration_closed_path
    end
  end


end


