class ReportCardMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def uploaded card
    @greeting = "Hi AEP administrator. A new report card has been uploaded for your review"
    @report_card = card
    mail to: "report_card_uploads@peterwestbrook.org", subject: "New report card uploaded"
  end


  def confirmation card, user
    @name = user.name
    @report_card = card
    mail to: user.email, subject: "Report card upload confirmation"
  end
end
