class ReportCardUploadedNotificationJob < ApplicationJob

  def perform report_card
    ReportCardMailer.uploaded(report_card).deliver_later
  end

end
