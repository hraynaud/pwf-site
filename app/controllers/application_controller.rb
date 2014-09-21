class ApplicationController < ActionController::Base
	layout "dashboard"
  protect_from_forgery
  #before_filter :check_season, :unless => Proc.new { |c| c.devise_controller? || c.kind_of?(ActiveAdmin::ResourceController) }
  before_filter :authenticate_user!, :unless => Proc.new { |c| c.devise_controller? || c.kind_of?(ActiveAdmin::ResourceController) }
  after_filter :set_csrf_cookie_for_ng

  helper_method :current_season, :current_parent, :current_user, :current_tutor
  def current_season
    @season ||= Season.current
  end

  def after_sign_in_path_for(resource)
    @resource = resource
    if resource.is_a?(User)
			return verify_updated_parent_profile if (resource.is_parent? || resource.profileable_type=="Parent")
      dashboard_path
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path
    end
  end


  def verify_updated_parent_profile
    if !@resource.profileable.current_household_profile.nil?
      dashboard_path
    else
      #NOTE The parent information is invalid redirect to the edit page
      #TODO determine if parent should be validated after every action?
      flash[:alert]="Your profile information is invalid:"
      #TODO figure out better way to get around the default rails behavior which validates the resource somehow on the call to respond_with/respond_to.
      #,fThis forces the path to be set back to the sign in path even though the user is signed in.
      edit_parent_path(@resource.profileable)
    end
  end

  def require_parent_user
		redirect_to dashboard_path, alert: denial_message("parent")  unless current_user.is_parent? or current_user.profileable_type == "Parent"
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

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def for_season
    season_id  = params[:season_id].present? ? params[:season_id] : Season.current_season_id
    @season = Season.find(season_id)
  end
protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

end


