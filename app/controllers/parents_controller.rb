class ParentsController < InheritedResources::Base
  def show
    @parent = current_user.profileable
    @uploader = @parent.avatar
    @uploader.success_action_redirect = avatar_parent_url(@parent)
  end

  def edit
    @parent = current_user.profileable
    @demographic = @parent.current_household_profile || @parent.demographics.build
  end

  def update
    update!{
      @demographic = @parent.current_household_profile
      dashboard_path
    }
  end
end

