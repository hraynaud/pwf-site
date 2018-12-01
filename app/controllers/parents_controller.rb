class ParentsController < ApplicationController
  before_action :load_parent

  def show
    @uploader = @parent.avatar
    @uploader.success_action_redirect = avatar_parent_url(@parent)
  end

  def edit
    @demographic = @parent.current_household_profile || @parent.demographics.build
  end

  def update

    @parent.photo.attach parent_params.delete(:photo)

    if @parent.update_attributes(parent_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def load_parent
    @parent = current_user
  end

  def parent_params
    params.require(:parent).permit(:first_name, :last_name, :photo,
    current_household_profile_attributes: [:num_adults,
    :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, :season_id],
    user_attributes:[])
  end
end
