class GeneralMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def notify parent, params
    @message = params['message']
    @name = parent.first_name

    if Rails.env.development? ||  ENV['BLOCK_MAILS']
      @name ="Dummy on behalf of: #{parent.name}(#{parent.email})"
      recipent_email = 'dummy@peterwestbrook.org'
    else
      recipent_email = parent.email
    end

    mail to: recipent_email, subject: params['subject']
  end 
end
