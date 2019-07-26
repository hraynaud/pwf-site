class MailNotificationJob < ApplicationJob

  def perform mail_args
    params = JSON.parse(mail_args)
    recipients(params).each do |recipient|
      execute_mailer recipient, params
    end
  end

  def execute_mailer recipient, params
    GeneralMailer.notify(recipient, params).deliver_later
  end

  def recipients params
    limit_unless_production base_query(params)
  end

  def base_query params
    NotificationService.recipient_list_for(params["mailing_list"]).exclude_selected(params['exclude_list']).distinct
  end

  private

  # no need to send tons of email 
  # for test and dev envirornments

  def limit_unless_production query
    if Rails.env.development?
      query.send(:limit, 2)
    else
      query
    end
  end
end
