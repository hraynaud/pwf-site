class RegistrationsController < Devise::RegistrationsController

  def complete

  end


  # def create
    # build_resource
    # if resource.save
      # if resource.active_for_authentication?
        # set_flash_message :notice, :signed_up if is_navigational_format?
        # sign_in(resource_name, resource)
        # loc = after_sign_up_path_for(resource)
        # respond_with resource, :location => loc
      # else
        # set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        # expire_session_data_after_sign_in!
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      # end
    # else
      # clean_up_passwords resource
      # respond_with resource
    # end
  # end


  def after_sign_up_path_for(resource)
    edit_parent_path(resource)
  end
end

