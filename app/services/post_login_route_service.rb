class PostLoginRouteService
  include  Rails.application.routes.url_helpers
  attr_reader :resource

  def initialize resource
    @resource = resource
  end

  def path
    if resource.is_a?(User)
      determine_user_signed_in_path
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path
    end
  end

  def determine_user_signed_in_path
      #return verify_updated_parent_profile if (resource.is_parent? || resource.profileable_type=="Parent")
      dashboard_path
  end 

  def verify_updated_parent_profile
    if !@resource.profileable.current_household_profile.nil?
      dashboard_path
    else
      flash[:alert]="Your profile information is invalid:"
      edit_parent_path(@resource.profileable)
    end
  end
end
