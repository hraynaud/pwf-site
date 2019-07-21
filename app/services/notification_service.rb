module NotificationService
  CONFIRMED="confirmed"
  PENDING="pending"
  AEP_ONLY="aep"
  WAIT_LIST="wait_listed"
  BACKLOG_WAIT_LIST = "backlog_wait_list"
  BLOCKED_ON_REPORT_CARD = "blocked_on_report_card"
  UNRENEWED_PARENTS = "unrenewed_parents"
  WAIT_LIST_PRIORITY = "wait_list_priority"

  DESCRIPTIONS ={
    "confirmed": "Enrolled Students",
    "pending": "Pending Students",
    "wait_listed": "Wait Listed Students",
    "aep": "AEP Students",
    "backlog_wait_list": "Waiting List Backlog",
    "blocked_on_report_card": "Missing Previous Season Report Card",
    "wait_list_priority": "Wait List Priority",
    "unrenewed_parents": "Registered last year but not this season"
  }

  module ReportCard
    class << self
      def missing params
        ReportCardMissingNotificationJob.perform_later params.to_json
      end
    end
  end

  module Announcement
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
    when BLOCKED_ON_REPORT_CARD
      Parent.with_blocked_on_report_card_registrations
    when BACKLOG_WAIT_LIST
      Parent.with_backlog_wait_listed_registrations
    when UNRENEWED_PARENTS
      Parent.with_unrenewed_registrations
    when WAIT_LIST_PRIORITY
      Parent.with_wait_list_priority
    else
      Parent.with_current_confirmed_registrations
    end
  end
end
