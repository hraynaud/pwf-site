class RegistrationsController < Devise::RegistrationsController

  skip_before_action :verify_updated_parent_profile
  private

  def after_sign_up_path_for(resource)
    if resource.is_a?(Parent)
      edit_parent_path(resource)
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path
    end
  end

  def sign_up_params
    @params ||= params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :type)
  end

end
