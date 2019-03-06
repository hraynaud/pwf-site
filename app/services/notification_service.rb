module NotificationService
  CONFIRMED="confirmed"
  PENDING="pending"
  AEP_ONLY="aep"
  WAIT_LIST="wait_listed"

  DESCRIPTIONS ={
    "confirmed": "Enrolled Students",
    "pending": "Pending Students",
    "wait_listed": "Wait Listed Students",
    "aep": "AEP Students",
  }


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

      def wait_list params
        MailNotificationJob.perform_later params.to_json
      end

    end
  end

  def self.description_for group
    DESCRIPTIONS[group.to_sym]
  end

  def self.recipient_list_for recipient_group
    case recipient_group
    when AEP_ONLY
      Parent.with_aep_registrations
    when PENDING
      Parent.with_current_pending_registrations
    when WAIT_LIST
      Parent.with_current_wait_listed_registrations
    else
      Parent.with_current_confirmed_registrations
    end
  end
end
