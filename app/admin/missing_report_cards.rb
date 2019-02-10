ActiveAdmin.register_page "Missing Report Cards" do
  menu parent: "Report Cards"
  content class: "active_admin" do

    @all = StudentRegistration.missing_first_session_report_cards
    @size = @all.size
    @page = @all.page(params[:page]).per(10) 
    panel "#{@size} Students with missing report cards", class: "test" do
      paginated_collection @page, entry_name: "missing", download_links: false do
        table_for @page.order("students.last_name asc"), class: "index_table", sortable: true  do
          column :student_name  do |reg|
            reg.student_name
          end

          column :parent do |reg|
            reg.parent_name
          end

          column :email do |reg|
            reg.parent.email
          end
        end
      end
    end
    panel "Send Emails Notifications" do 
      form action: admin_missing_report_cards_send_notifications_path, method: :post do

        div do
          hidden_field_tag :authenticity_token, form_authenticity_token
        end

        columns do 
          column do 

            h3 "Email Message"

            div do
              label "Subject Line"
            end

            div do
              input name: "subject", class: "mail-subject"
            end
            div do
              label "Message" do
                textarea name: "message", class: "mail-message"
              end
            end
          end

          column do
            h3 "Do not notify"
            div do
              label "Select students who should get this email"
            end


            div class: "chosen-wrap" do 
              select multiple: "multiple", name: "exclude_list[]" do
                options_from_collection_for_select( @all, :id, :student_name)
              end
            end
          end
        end

        div do 
          button "Send Email Notifications"
        end
      end
    end
  end

  page_action :send_notifications, method: :post do
    NotificationService::ReportCard.missing params.slice("subject", "message", "exclude_list")
    redirect_to admin_missing_report_cards_path, notice: "Missing report cards notices sent"
  end

  page_action :csv, method: :get do
    missing_report_cards = StudentRegistration.missing_first_session_report_cards
    csv_data = CSV.generate( encoding: 'Windows-1251' ) do |csv|
      csv << [ "Student", "Parent", "Email"]
      missing_report_cards.each do |missing|
        csv << [ missing.student_name, missing.parent.name, missing.parent.email]
      end
    end
    send_data csv_data.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=missing_report_cards_#{DateTime.now.to_s}.csv"
  end

  action_item :add do
    link_to "Export to CSV", admin_missing_report_cards_csv_path, method: :get, format: :csv
  end

  sidebar "Dowload" do
    div link_to "Export List CSV file", admin_missing_report_cards_csv_path, method: :get, format: :csv
  end

end

