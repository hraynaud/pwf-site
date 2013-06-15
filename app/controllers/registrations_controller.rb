class RegistrationsController < Devise::RegistrationsController

  def new
    if(current_season.open_enrollment_enabled)
      session[:parent_params] ||= {}
      @parent = Parent.new(session[:parent_params])
      @parent.current_step = session[:parent_step]
    else
      flash[:notice] = "Open Enrollement for new registrations opens on #{current_season.open_enrollment_date}"
      redirect_to root_path
    end
  end

  def create
    session[:parent_params].deep_merge!(params[:parent]) if params[:parent]
    @parent = Parent.new(session[:parent_params])
    @parent.current_step = session[:parent_step]
    if @parent.valid?
      if params[:back_button]
        @parent.previous_step
      elsif @parent.last_step?
        @parent.save if @parent.all_valid?
      else
        @parent.next_step
      end
      session[:parent_step] = @parent.current_step
    end

    if @parent.new_record?
      @parent.build_current_household_profile(:season_id => Season.current.id) if demographics_needed?
      render "new"
    else
      session[:parent_step] = session[:parent_params] = nil
      flash[:notice] = "parent saved!"
      sign_in(@parent)
      redirect_to @parent
    end

  end

  def after_sign_up_path_for(resource)
    parent_path(resource)
  end

  private
  def demographics_needed?
    if @parent.current_step == "demographics"
      !session[:parent_params].has_key? "current_household_profile_attributes"
    end
  end
end

