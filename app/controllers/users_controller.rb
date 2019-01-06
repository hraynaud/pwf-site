class UsersController < InheritedResources::Base
  def show
    @user = current_user
  end

  def edit
    @user =current_user
  end


  def user_params
 params.require(:user).permit( :email, :password, :password_confirmation, :first_name, :last_name,:address1, :address2, :city, :state, :zip, :primary_phone, :secondary_phone, :other_phone)
  end

end

