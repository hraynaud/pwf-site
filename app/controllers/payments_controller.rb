class PaymentsController < ApplicationController
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def new
    @payment = current_parent.payments.build
    @pending_registrations = current_parent.current_unpaid_pending_registrations
    @total_price = @pending_registrations.count * Season.current.fencing_fee
  end

  def show
    @payment = Payment.find(params[:id])
    @total_price = @payment.amount
  end

  def create
    @payment = Payment.create params[:payment]
    if @payment.valid?
      if paid_with_card?
        redirect_to @payment, :notice => "Payment Transaction Completed"
      else
        do_paypal(@payment)
      end

    else
      @total_price = current_cart.total_price
      render :new
    end
  end

  def destroy
    Payment.find_by_identifier!(params[:id]).unsubscribe!
    redirect_to root_path, notice: 'Recurring Profile Canceled'
  end

  def success
    handle_callback do |payment|
      @payment = payment
      payment.complete!(params[:PayerID])
      flash[:notice] = 'Payment Transaction Completed'
      payment_path(payment)
    end
  end

  def cancel
    handle_callback do |payment|
      payment.cancel!
      flash[:warn] = 'Payment Request Canceled'
      root_url
    end
  end

  private

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
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end

  def paid_with_card?
    params[:payment][:payment_method]=="card"
  end

  def do_paypal(payment)
    payment.setup_paypal!(
      success_payments_url,
      cancel_payments_url
    )
    if payment.popup?
      redirect_to payment.popup_uri
    else
      redirect_to payment.redirect_uri
    end
  end

end
