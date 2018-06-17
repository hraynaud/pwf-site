class RegistrationsController < Devise::RegistrationsController
  def new
    @user =  User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to new_user_contact_detail_path(@user)
    else
      flash[:error] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params 
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
