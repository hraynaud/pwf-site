class ReportCardMissingNotificationJob < ApplicationJob

  def perform mail_args
    params = JSON.parse(mail_args)
    recipients(params).each do |student|
      ReportCardMailer.missing(student, params).deliver_later
    end
  end


  def recipients params
    limit_unless_production base_query(params)
  end

  def base_query params
    StudentRegistration.where
      .not(id: params['exclude_list'])
      .with_unsubmitted_transcript_for(params['term_id'])
  end

  # no need to send tons of email for test envirornments
  def limit_unless_production query
    if Rails.env.development? || ENV['BLOCK_MAILS']
      query.send(:limit, 2)
    else
      query
    end
  end
end
