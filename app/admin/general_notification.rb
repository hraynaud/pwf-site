ActiveAdmin.register_page "General Notification" do
  menu parent: "Notifications", label: "General"

  controller do 
    before_action do
      @mailing_list = params[:mailing_list] || NotificationService::CONFIRMED
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

  sidebar "Filter" do
    form action: admin_general_notification_path, class: "filter_form" do

      div class: "filter_form_field" do 
        label "Parent Group" 
        select name: "mailing_list" do
          option "Enrolled Students", value: NotificationService::CONFIRMED, selected: NotificationService::CONFIRMED == mailing_list
          option "Pending Students", value: NotificationService::PENDING, selected: NotificationService::PENDING == mailing_list
          option "Wait Listed Students", value: NotificationService::WAIT_LIST, selected: NotificationService::WAIT_LIST == mailing_list
          option "AEP Students", value: NotificationService::AEP_ONLY, selected: NotificationService::AEP_ONLY == mailing_list
          option "Unrenewed Registrations", value: NotificationService::UNRENEWED_PARENTS, selected: NotificationService::UNRENEWED_PARENTS == mailing_list
        end
      end

      div class: "buttons" do
        button "Filter"
      end
    end

  end
end
