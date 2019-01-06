class ReportCardMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def uploaded card
    @greeting = "Hi AEP administrator. A new report card has been uploaded for your review"
    @report_card = card
    mail to: "report_card_uploads@peterwestbrook.org", subject: "New report card uploaded"
  end

end
