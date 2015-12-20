class ReportCardMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_cards.uploaded.subject
  #
  def uploaded rep_card
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
