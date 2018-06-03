class PaymentsController < ApplicationController
  before_action :require_parent_user

  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def new
    @payment = current_parent.payments.build
    prog = params[:program].try(:to_sym) || :fencing
    @prog = prog.to_s.titleize
    @fee_type = Payment.programs(prog)
    @total_payment, @registrations = total_payment_for_programs(prog)
    @fee = Season.current.fee_for(prog)
  end

  def show
    @payment = current_parent.payments.find(params[:id])
    @total_payment = @payment.amount
    @registrations = @payment.attached_registrations
    @fee = Season.current.fee_for(@payment.program)
  rescue  ActiveRecord::RecordNotFound
    flash[:alert]="You have no payments with that id"
    redirect_to root_path
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
      render :new
    end
  end


  def with_card
    if @payment.save_with_stripe!
      redirect_to @payment, :notice => "Payment Transaction Completed"
    else
      @registrations = current_parent.current_unpaid_pending_registrations
      @total_price = @registrations.count * Season.current.fencing_fee
      render :new
    end
  end


  private

  def total_payment_for_programs(prog_type)
    if @fee_type==Payment.fencing
      [current_parent.unpaid_fencing_registration_amount, current_parent.current_unpaid_pending_registrations]
    else
      [current_parent.unpaid_aep_registration_amount, current_parent.current_unpaid_aep_registrations]
    end
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
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end




end
