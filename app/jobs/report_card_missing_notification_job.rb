class ReportCardMissingNotificationJob < ApplicationJob

  def perform args
    params = JSON.parse(args)
    recipients(params['exclude_list']).each do |student|
      ReportCardMailer.missing(student, params['subject'], params['message']).deliver_later
    end
  end


  def recipients exclude_list
    limit_unless_production base_query(exclude_list)
  end

  def base_query exclude_list
    StudentRegistration.where
      .not(id: exclude_list)
      .missing_first_session_report_cards
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
