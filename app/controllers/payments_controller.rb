class PaymentsController < ApplicationController
  before_action :require_parent_user

  def index
    @payments = current_parent.payments
  end

  def new
    @payment = current_parent.payments.build(program: params[:program])
  end

  def show
    @payment = current_parent.payments.find(params[:id])
    render layout: "print" if params[:print].present?
  end

  def create
    @payment = current_parent.payments.build payment_params
    if @payment.save
      redirect_to @payment, :notice => "Payment Transaction Completed"
    else
      render :new
    end
  end

  private


  def payment_params
    params.require(:payment).permit(
      :amount, :parent_id, :program_cd, 
      :stripe_card_token, :stripe_charge_id, :payment_medium_cd, :email, :first_name, :last_name, :pay_with, 
)
  end

end
