class ParentsController < ApplicationController

  skip_before_action :verify_updated_parent_profile
  before_action :load_parent
  before_action :build_reg_profile, unless: :reg_complete?, only: [:edit]
  layout :parent_layout

  def show
    @uploader = @parent.avatar
    @uploader.success_action_redirect = avatar_parent_url(@parent)
  end

  def update
    photo = parent_params.delete(:photo)
    @parent.photo.attach photo if photo
    @parent.assign_attributes(parent_params)
    if @parent.save
      session[:reg_complete] = true
      redirect_to dashboard_path, notice: "Profile information saved"
    else
      render :edit
    end
  end

  private
  def parent_layout
    reg_complete?  ? "application" : "plain"
  end

  def load_parent
    @parent = current_user
  end

  def build_reg_profile
    @parent.build_current_household_profile if @parent.current_household_profile.nil?
    @parent.build_contact_detail if @parent.contact_detail.nil?
  end

  def parent_params
    params.require(:parent).permit(
      :first_name, :last_name, :photo,:keep_and_notify_if_waitlisted, :validate_user_fields_only,
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
