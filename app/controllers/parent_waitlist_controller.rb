class ParentWaitlistController < ParentsController
  layout false

  def update
    @parent.assign_attributes(parent_params)
    if @parent.save
      redirect_to waitlist_updated_path, notice: "Settings updated. You will now be logged out"
    else
      render :edit, layout: nil
    end
  end

  def thanks
    sign_out(current_user)
  end

end


