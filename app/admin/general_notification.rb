ActiveAdmin.register_page "General Notification" do
  menu parent: "Notifications", label: "General"

  controller do 
    before_action do
      @mailing_list = params[:mailing_list] || NotificationService::CONFIRMED
      @students=  NotificationService.recipient_list_for(@mailing_list).columns_for_student_registration
    end

  end

  content class: "active_admin sidebar-wide" do
    div class: "mailing-info" do
      h2 "Sending to:", class: "mailing-hdr" do 
        span "#{NotificationService.description_for mailing_list}", class: "mailing-grp-name"
      end
    end
    render "/admin/notifications/mail_form",locals:{students: @students}
  end

  page_action :deliver, method: :post do
    NotificationService::Announcement.general params[:email_template]
    redirect_to admin_notification_sent_path, notice: "Notifications sent"
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
          option "Blocked on Report Card", value: NotificationService::BLOCKED_ON_REPORT_CARD, selected: NotificationService::BLOCKED_ON_REPORT_CARD == mailing_list
          option "Unrenewed Registrations", value: NotificationService::UNRENEWED_PARENTS, selected: NotificationService::UNRENEWED_PARENTS == mailing_list
          option "Priority Waitlist", value: NotificationService::WAIT_LIST_PRIORITY, selected: NotificationService::WAIT_LIST_PRIORITY == mailing_list
          option "Seniors", value: NotificationService::SENIORS, selected: NotificationService::SENIORS == mailing_list
        end
      end

      div class: "buttons" do
        button "Filter"
      end
    end
  end

end
