ActiveAdmin.register_page "Notification Sent" do
  menu false

  content do 
    div class: "confirmation-msg" do 
      h2 do
        "Your emails have been submitted for delivery"
      end

      div do
        a "Return to Notifications", href: admin_general_notification_path 
        text_node "or"
        a "Return to Dashboard", href: admin_dashboard_path 
      end
    end
  end
end
