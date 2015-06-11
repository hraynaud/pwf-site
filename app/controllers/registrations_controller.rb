class RegistrationsController < Devise::RegistrationsController
  before_filter :check_season, only: [:new, :create]
  def new
    if(current_season.open_enrollment_enabled)
      session[:parent_params] ||= {}
      @parent = Parent.new(session[:parent_params])
      @parent.build_user
      @parent.user.is_parent = true
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
      @demographic = (@parent.current_household_profile || @parent.demographics.build(:season_id => Season.current.id)) if demographics_needed?
      render "new"
    else
      session[:parent_step] = session[:parent_params] = nil
      flash[:notice] = "parent saved!"
      sign_in(@parent.user)
      redirect_to dashboard_path 
    end

  end

  private
  def demographics_needed?
    if @parent.current_step == "demographics"
      !session[:parent_params].has_key? "demographics_attributes"
    end
  end
end

