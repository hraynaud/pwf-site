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

  def missing missing, params
    @name = missing.parent_first_name
    @student = missing.student_name
    @term = MarkingPeriod.send(params['term'].to_sym)
    @message = params['message']
    mail to: email_address_for(missing), subject: params['subject']
  end

  def email_address_for missing
    if ENV['BLOCK_MAILS'] || Rails.env.development?
      "dummy-email@peterwestbrook.org"
      #Iisadummy
    else
      missing.parent_email
    end
  end
end
