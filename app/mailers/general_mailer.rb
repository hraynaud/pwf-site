class GeneralMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def notify parent, params
    @name = parent.first_name
    @message = params['message']
    mail to: parent.email, subject: params['subject']
  end 
end
