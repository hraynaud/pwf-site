class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_season, :unless => Proc.new { |c| c.devise_controller? || c.kind_of?(ActiveAdmin::ResourceController) }
  before_filter :authenticate_user!, :unless => Proc.new { |c| c.devise_controller? || c.kind_of?(ActiveAdmin::ResourceController) }

  helper_method :current_season, :current_parent, :current_user
  def current_season
    @season ||= Season.current
  end

  def after_sign_in_path_for(resource)
    @resource = resource

    if resource.is_a?(User)
      return verify_updated_parent_profile if resource.is_parent?
      dashboard_path
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path
    end
  end


  def verify_updated_parent_profile
    if @resource.profileable.all_valid?
      dashboard_path
    else
      #NOTE The parent information is invalid redirect to the edit page
      #TODO determine if parent should be validated after every action?
      flash[:alert]="You profile information is invalid:"
      #TODO figure out better way to get around the default rails behavior which validates the resource somehow on the call to respond_with/respond_to.
      #,fThis forces the path to be set back to the sign in path even though the user is signed in.
      edit_parent_path(@resource.profileable)
    end
  end

  def require_parent_user
    redirect_to dashboard_path, alert: denial_message("parent")  unless current_user.is_parent?
  end

  def require_tutor_user
    redirect_to dashboard_path, alert: denial_message("tutor")  unless current_user.is_tutor?
  end

  def require_mgr_user
    redirect_to dashboard_path, alert: denial_message("manager")  unless current_user.is_mgr?
  end

  def check_season
    if current_season.status == "Closed"
      redirect_to registration_closed_path
    end
  end

  def current_parent
    current_user.profileable
  end

  def current_tutor
    current_user.profileable
  end


  def denial_message type
    "Access Denied! You must be #{type} to view that resource"
  end
end


