class ContactDetailsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_user
  respond_to :html

  def new
     @contact_detail = @user.build_contact_detail
     respond_with @contact_detail
  end

  def create
    @contact_detail = @user.build_contact_detail(contact_detail_params)
    if @contact_detail.valid?
      redirect_to dashboard_path
    else
      respond_with @contact_detail
    end
  end


  private
  def find_user
     @user =User.find(params[:user_id])
  end

  def contact_detail_params
    params.require(:contact_detail).permit(:address1, :address2, :city, :state, :zip, :primary_phone, :secondary_phone, :other_phone)
  end

end
