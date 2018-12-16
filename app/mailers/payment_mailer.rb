class PaymentMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def notify payment
    @payment = payment
    mail to: @payment.parent_email, subject: "Peter Westbrook Foundataion: Payment Received"
  end

end
