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
  private
  def parent_params
    parmams.require(:parent).permit(
    current_household_profile_attributes: [:num_adults,
    :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season_id],
    user_attributes:[])
  end
end
