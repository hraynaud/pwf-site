ActiveAdmin.register_page "Waitlist Management" do
  menu parent: "Notifications", label: "Waitlist Management"

  controller do 
    before_action do
      @mailing_list = NotificationService::BACKLOG_WAIT_LIST
      @recipients =  NotificationService.recipient_list_for @mailing_list
    end
  end

  content class: "active_admin" do
    div class: "mailing-info" do
      h2 "Sending to parents of current:", class: "mailing-hdr" do 
        span "#{NotificationService.description_for mailing_list}", class: "mailing-grp-name"
      end
      div class: "mailing-grp-details" do
        "#{recipients.distinct.count} parents  will recieve this email
        for #{recipients.count} Students"
      end
    end
    render "/admin/notifications/mail_form"
  end

  page_action :deliver, method: :post do
    NotificationService::Announcement.general params[:email_template]
    redirect_to admin_general_notification_path, notice: "Notifications sent"
  end

end
