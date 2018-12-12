class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  before_action :verify_updated_parent_profile
  after_action :set_csrf_cookie_for_ng

  helper_method :current_season, :current_user, :current_user, :current_tutor, :render_photo, :render_avatar, :render_thumbnail

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def reg_complete?
   session[:reg_complete]
  end

 private

  def current_season
    @season ||= Season.current
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Parent)
      session[:reg_complete] = current_user.curr_registration_complete?
       dashboard_path
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path
    end
  end

  def denial_message type 
    "Access Denied! You must be #{type} to view that resource"
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verify_updated_parent_profile
    if  reg_complete?
      dashboard_path
    else
      flash[:alert]="Your profile information is incomplete or invalid. Please update before proceeding:"
      redirect_to edit_parent_path(current_user)
    end
  end

  def for_season
    season_id  = params[:season_id].present? ? params[:season_id] : Season.current_season_id
    @season = Season.find(season_id)
  end

  def render_avatar resource
    render_as_variant resource, "128x128"
  end

  def render_thumbnail resource
    (resource.photo && resource.photo.attached?) ? resource.photo.variant(resize: "128x128") : "user-place-holder-128x128.png"
  end

  def render_as_variant resource, size
    (resource.photo && resource.photo.attached?) ? resource.photo.variant(resize: size) : "user-place-holder-128x128.png"
  end

end


