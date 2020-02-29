class ReportCardMissingNotificationJob < MailNotificationJob

  def base_query params
    StudentRegistration.current.confirmed.missing_report_card_for(params["term_id"]).exclude_selected(params['exclude_list'])
  end

  def execute_mailer recipient, params
    ReportCardMailer.missing(recipient, params).deliver_later
  end

end
