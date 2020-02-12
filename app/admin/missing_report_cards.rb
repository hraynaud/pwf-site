ActiveAdmin.register_page "Missing Report Cards" do
  menu parent: "Notifications"

  controller do 

    #FIXME this is crap HR2020-02-08
    def term
     t =  params[:term] || "fall_winter"
    end

    def marking_period
     MarkingPeriod.by_session_name(session_name)
    end

    def session_name
      MarkingPeriod.send(term.to_sym)
    end


  end

  content class: "active_admin" do
    @session_name = controller.session_name
    @marking_period = controller.marking_period

    @all =  StudentRegistration.current.confirmed.missing_report_card_for(@marking_period)
    @size = @all.size
    @page = @all.page(params[:page]).per(10)
    @mail = MissingReportCardEmailTemplate.new

    panel "#{@size} Students with missing #{@session_name} report cards", class: "test" do
      paginated_collection @page, entry_name: "missing", download_links: false do
        table_for @page, class: "index_table", sortable: true  do
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
                f.input :term_id, as: :hidden, input_html: {value: @marking_period.id}
              end

              div do
                f.input :term, as: :hidden, input_html: {value: @session_name}
              end

              h3 "Email Message"

              div do
                label "Subject Line"
              end

              div do
                f.input :subject, class: "mail-subject", label: false, required: true
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
                label "Select students who should not get this email"
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

  page_action :send_notifications, method: :post do
    if params["subject"].present? && params["message"].present?
      NotificationService::ReportCard.missing params[:missing_report_card_email_template]
      redirect_to admin_missing_report_cards_path, notice: "Missing report cards notices sent"
    else
      flash[:error] = "Missing subject or message in email"
      redirect_to admin_missing_report_cards_path, error: "Opps"
    end
  end

  page_action :csv, method: :get do
    missing_report_cards =  StudentRegistration.current.confirmed.missing_report_card_for(marking_period)

    csv_data = CSV.generate( encoding: 'Windows-1251') do |csv|
      csv << [ "Student", "Parent", "Email", "Registration Id" ]
      missing_report_cards.each do |missing|
        csv << [ missing.student_name, missing.parent.name, missing.parent.email, missing.id]
      end
    end

    send_data csv_data.encode('Windows-1251', invalid: :replace, undef: :replace,  replace: ' '), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=missing_report_cards_#{DateTime.now.to_s}.csv"
  end
end

