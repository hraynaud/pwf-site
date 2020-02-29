ActiveAdmin.register_page "Report Card Notification Sent" do
  menu false

  content do 
    div class: "confirmation-msg" do 
      h2 do
        "Your report card notification emails have been submitted for delivery"
      end

      div do
        a "Return to report card notifications", href: admin_missing_report_cards_path 
        text_node "or"
        a "Return to Dashboard", href: admin_dashboard_path 
      end
    end
  end
end
