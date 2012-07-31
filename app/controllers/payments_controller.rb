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
    @payment = current_parent.payments.build params[:payment]
    if params[:payment][:pay_with] == "card"
      with_card
    else
      with_paypal
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
    end
  end


  def with_card
    if @payment.save_with_stripe!
      redirect_to @payment, :notice => "Payment Transaction Completed"
    else
      @pending_registrations = current_parent.current_unpaid_pending_registrations
      @total_price = @pending_registrations.count * Season.current.fencing_fee
      render :new
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




end
