ActiveAdmin.register_page "Notifications" do
  menu parent: "Notifications", label: "General"

  controller do 

    def grp
      params[:grp] || "all"
    end

    def index
      @grp = grp
    end

  end

  content class: "active_admin" do
    @all =  Parent.with_confirmed_registrations
    @mail = EmailTemplate.new

    panel "Send Email Notifications" do 

      form action: admin_notifications_send_notifications_path, method: :post do
        semantic_fields_for @mail do |f|
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
              h3 "Recipients"
              div do
                "#{Parent.with_confirmed_registrations.count} parent will recieve this email
                for #{StudentRegistration.confirmed_students_count} Students"
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
    NotificationService::Announcement.general params[:email_template]
    redirect_to admin_notifications_path, notice: "Notifications sent"
  end

  sidebar :filter do
    @grp = controller.grp
    form action: admin_notifications_path do

      div class: "form-elmenent-grp inline"do
        label "All" do
          input type: "radio", name: "grp", value: "all", checked: @grp=="all"
        end
      end

      div class: "form-elmenent-grp inline"do
        label "In AEP (Paid) " do
          input type: "radio", name: "grp", value: "aep", checked: @grp == "aep"
        end
      end

      div do
        button "Filter"
      end
    end
  end
end
