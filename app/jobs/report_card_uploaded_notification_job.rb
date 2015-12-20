class ReportCardUploadedNotificationJob
  def initialize (report_card_id)
    @id = report_card_id
  end

  def perform
    card= ReportCard.find(@id)
    ReportCardMailer.uploaded(card).deliver
  end

end
