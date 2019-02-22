ActiveAdmin.register_page "Missing Report Cards" do
  menu parent: "Report Cards"

  controller do 

    def term
      params[:term] || "fall_winter"
    end

  end

  content class: "active_admin" do
    @term = controller.term
    @all =  StudentRegistration.missing_report_card_for(@term)
    @size = @all.size
    @page = @all.page(params[:page]).per(10)
    @mail = MissingReportCardEmailTemplate.new

    panel "#{@size} Students with missing #{@term} report cards", class: "test" do
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
        semantic_fields_for @mail do |f|
          div do
            hidden_field_tag :authenticity_token, form_authenticity_token
          end

          columns do 
            column do 

              div do
                f.input :term_id, as: :hidden, input_html: {value: @term_id}
              end

              div do
                f.input :term, as: :hidden, input_html: {value: @term}
              end

              h3 "Email Message"

              div do
                label "Subject Line"
              end

              div do
                f.input :subject, class: "mail-subject", label: false
              end

              div do
                label "Message"
              end

              div do
                f.input :message, class: "mail-message", label: false, as: :medium_editor, input_html: { data: { options: '{"spellcheck":false,"toolbar":{"buttons":["bold","italic","underline","anchor"]}}' } } 
              end

            end

            column do
              h3 "Do not notify"
              div do
                label "Select students who should get this email"
              end

              div class: "chosen-wrap" do
                f.input :exclude_list, label: false, as: :select,  include_hidden: false , input_html: {multiple: true}, collection: @all.map{|n| [n.student_name, n.id]}
              end
            end
          end

          div do 
            f.submit "Send Email Notifications"
          end
        end
      end
    end
  end

  page_action :send_notifications, method: :post do
    NotificationService::ReportCard.missing params[:missing_report_card_email_template]
    redirect_to admin_missing_report_cards_path, notice: "Missing report cards notices sent"
  end

  page_action :csv, method: :get do
    missing_report_cards =  StudentRegistration.missing_report_card_for(term)

    csv_data = CSV.generate( encoding: 'Windows-1251' ) do |csv|
      csv << [ "Student", "Parent", "Email"]
      missing_report_cards.each do |missing|
        csv << [ missing.student_name, missing.parent.name, missing.parent.email]
      end
    end

    send_data csv_data.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=missing_report_cards_#{DateTime.now.to_s}.csv"
  end

  sidebar :filter do

    @term = controller.term

    form action: admin_missing_report_cards_path do

      div class: "form-elmenent-grp inline"do
        label MarkingPeriod.fall_winter do
          input type: "radio", name: "term", value: "fall_winter", checked: @term == "fall_winter"
        end
      end

      div class: "form-elmenent-grp inline"do
        label MarkingPeriod.spring_summer do
          input type: "radio", name: "term", value: "spring_summer", checked: @term == "spring_summer"
        end
      end

      div do
        button "Filter by marking period"
      end
    end
  end

  sidebar "Dowload" do
    div link_to "Export List CSV file", admin_missing_report_cards_csv_path(term: controller.term), method: :get, format: :csv
  end

end

