module NotificationService

  class ReportCard
    class << self
      def missing params
        ReportCardMissingNotificationJob.perform_later params.to_json
      end
    end
  end

  class Announcement
    class << self
      def general params
        MailNotificationJob.perform_later params.to_json
      end
    end
  end



end
