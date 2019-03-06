class ParentWaitlistController < ParentsController

  def update
    @parent.assign_attributes(parent_params)
    if @parent.save
      redirect_to waitlist_upated_path, notice: "Settings updated. You will now be logged out"
    else
      render :edit
    end
  end

  def thanks
    sign_out(current_user)
  end

end


