class PaymentsController < ApplicationController
  before_action :require_parent_user
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def index
    @payments = current_parent.payments
  end

  def new
    @payment = current_parent.payments.build(program: params[:program])
  end

  def show
    @payment = current_parent.payments.find(params[:id])
    render layout: "print" if params[:print].present?

  rescue  ActiveRecord::RecordNotFound
    flash[:alert]="You have no payments with that id"
    redirect_to root_path
  end

  def create
    @payment = current_parent.payments.build payment_params
    if @payment.save
      redirect_to @payment, :notice => "Payment Transaction Completed"
    else
      render :new
    end

  end

  def destroy
    Payment.find_by_identifier!(params[:id]).unsubscribe!
    redirect_to root_path, notice: 'Recurring Profile Canceled'
  end

  def paypal_success
    handle_callback do |payment|
      @payment = payment
      payment.paypal_complete!(params[:PayerID])
      flash[:notice] = 'Payment Transaction Completed'
      payment_path(payment)
    end
  end

  def paypal_cancel
    handle_callback do |payment|
      payment.cancel!
      flash[:warn] = 'Payment Request Canceled'
      root_url
    end
  end

  private

  def with_paypal
    @payment.save_with_paypal!(
      paypal_success_payments_url,
      paypal_cancel_payments_url
    )
    if @payment.valid?
      if @payment.popup?
        redirect_to @payment.popup_uri
      else
        redirect_to @payment.redirect_uri
      end
    else
      flash[:notice] = @payment.errors.full_messages
      render :new
    end
  end

  def payment_params
    params.require(:payment).permit(
      :amount, :parent_id, :program_cd, 
      :stripe_card_token, :stripe_charge_id, :payment_medium_cd, :email, :first_name, :last_name, :pay_with)
  end

  def handle_callback
    payment = Payment.find_by_token! params[:token]
    @redirect_uri = yield payment
    if payment.popup?
      render :close_flow, layout: false
    else
      redirect_to @redirect_uri
    end
  end

  def paypal_api_error(e)
    redirect_to root_dastboard_path, error: e.response.details.collect(&:long_message).join('<br />')
  end

end
