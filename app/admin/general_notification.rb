ActiveAdmin.register_page "General Notification" do
  menu parent: "Notifications", label: "General"

  controller do 
    before_action do
      @grp = params[:grp] || "enrolled"
      @all_parents =  Parent.with_confirmed_registrations
      @all_students = StudentRegistration.confirmed_students_count
    end

  end

  content class: "active_admin" do
    render "/admin/notifications/mail_form"
  end

 page_action :deliver, method: :post do
    NotificationService::Announcement.general params[:email_template]
    redirect_to admin_notifications_path, notice: "Notifications sent"
  end

  sidebar "Filter" do
    form action: admin_general_notification_path, class: "filter_form" do

      div class: "filter_form_field" do 
        label "Parent Group" 
        select name: "grp" do
          option "Enrolled Students", value: "enrolled"
          option "AEP Students", value: "aep"
          option "Pending Students", value: "pending"
          option "Wait Listed", value: "waitlisted"
        end
      end

      div class: "buttons" do
        button "Filter"
      end
    end

  end
end
