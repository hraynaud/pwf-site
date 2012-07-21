class RegistrationsController < Devise::RegistrationsController

  def new
    session[:parent_params] ||= {}
    @parent = Parent.new(session[:parent_params])
    @parent.current_step = session[:parent_step]
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
      @parent.build_demographics if demographics_needed?
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
      !session[:parent_params].has_key? "demographics_attributes"
    end
  end
end

