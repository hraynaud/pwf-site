class ReportCardMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_cards.uploaded.subject
  #
  def uploaded card
    @greeting = "Hi AEP administrator. A new report card has been uploaded for your review"
    @report_card = card
    mail to: "report_card_uploads@peterwestbrook.org", subject: "New report card uploaded"

  end
end
