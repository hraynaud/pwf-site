ActiveAdmin.register_page "Waitlist Notification" do
  menu parent: "Notifications", label: "Wait List"

  controller do 
    before_action do
      @grp = params[:grp] || "all"
    end
  end

  content class: "active_admin" do
    render "/admin/notifications/mail_form"
  end

  page_action :deliver, method: :post do
    NotificationService::Announcement.general params[:email_template]
    redirect_to admin_notifications_path, notice: "Notifications sent"
  end

  sidebar :filter do
    form action: admin_general_notification_path do

      div class: "form-elmenent-grp inline"do
        label "All" do
          input type: "radio", name: "grp", value: "all", checked: grp == "all"
        end
      end

      div class: "form-elmenent-grp inline"do
        label "In AEP (Paid) " do
          input type: "radio", name: "grp", value: "aep", checked: grp == "aep"
        end
      end

      div do
        button "Filter"
      end
    end

  end
end
