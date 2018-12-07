class ParentsController < ApplicationController
  before_action :load_parent

  def show
    @uploader = @parent.avatar
    @uploader.success_action_redirect = avatar_parent_url(@parent)
  end

  def edit
    @parent.demographics.build if @parent.current_household_profile.nil?
    @parent.build_contact_detail if @parent.contact_detail.nil?
  end


  def update
    photo = parent_params.delete(:photo)
    @parent.photo.attach photo  if photo
    @parent.assign_attributes(parent_params)
    if @parent.save
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
    params.require(:parent).permit(
      :first_name, :last_name, :photo,
      contact_detail_attributes: [
        :address1, :address2, :city, :state, :zip, :primary_phone, 
        :secondary_phone, :other_phone
      ], 
      current_household_profile_attributes: [
        :num_adults,
        :num_minors, :income_range_cd, :education_level_cd, :home_ownership_cd, 
        :season_id
      ]
    )
  end
end
