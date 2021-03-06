ActiveAdmin.register StudentRegistration,  as: "Attendance Calculation" do

  includes :student, :attendances

  menu  parent: "Administration", label: "Attendance Calculation"
  config.filters = false
  config.clear_action_items!

  breadcrumb do
    ['admin', Season.current.description]
  end

  scope "Hoodies & T-shirts", group: :awarded, default: true do |regs|
    AttendanceAwards.hoodies regs, params
  end

  scope "T-shirts Only" , group: :awarded do |regs|
    AttendanceAwards.t_shirts regs, params
  end

  scope "No Award", scop: :no_award do |regs|
    AttendanceAwards.no_award regs, params
  end

  scope :all

  controller do
    def scoped_collection
      StudentRegistration.current.confirmed.joins(:student)
    end
  end

  collection_action :pdf, method: :get do
    disp = params[:disposition].present? ? params[:disposition] : "attachment"
    pdf = AttendanceAwardSheetPdf.new(params)
    send_data pdf.render , filename: "hoodies_list.pdf", type: "application/pdf", disposition: disp
  end

  index download_links: -> { [:csv]  }  do
    column :last_name, :sortable =>'students.last_name' do |reg|
      link_to reg.student.last_name.capitalize, admin_student_path(reg.student) 
    end
    column :first_name, :sortable =>'students.first_name' do |reg|
      link_to reg.student.first_name.capitalize, admin_student_path(reg.student)
    end

    column "Attendances" do |reg|
      reg.attendances.present.count
    end

    column "T-Shirt Size", :size_cd do |reg|
      reg.size
    end
  end

  sidebar "Attendance Percentage Tester" do
    div do
      div class: "inline" do 
        text_node "There have been"
        h4 class: "inline" do Season.current.num_sessions end
        text_node " classes as of today."
      end

      para ""
      para "Set a value for  the minimum attendance % for either or both hoodies and t-shirts,  then click submit to see how the number of recipients changes."
      para "The number of attendances is calculated for the corresponding percentage value"
      para "Click reset to go back to the default value set for the season."

      form class: "filter_form", action: admin_attendance_calculations_path do

        div class: "form-element-grp inline"do
          label "Hoodies % (#{AttendanceAwards.hoodie_count(params)} attendances)" do
            input type: "text", name: "q[h_eq]", value: AttendanceAwards.hoodie_pct(params)
          end
        end

        div class: "form-element-grp inline"do
          label "T-shirts % ( #{AttendanceAwards.t_shirt_count(params)} attendances)" do
            input type: "text", name: "q[t_eq]", value: AttendanceAwards.t_shirt_pct(params)
          end
        end

        div class: "form-element-grp inline" do
          label "Cut Off Date" do
            select name: "q[asof_eq]" do
              Season.current.attendance_sheets.order("session_date desc").each do |sheet|
                option sheet.session_date,  value: sheet.session_date,  selected: (sheet.session_date.to_s == params["q"]["asof_eq"] if params["q"])
              end
            end
          end
        end

        div class: "buttons" do

          button "Submit", type: "submit"
          a "Reset", class: "clear_filters_btn",  href: "#"
        end
      end
    end
  end
 
  sidebar "Order Summary" do
    div do

      regs =StudentRegistration.current.confirmed 
      hoodies = AttendanceAwards.hoodies_breakdown(regs, params)
      tshirts = AttendanceAwards.t_shirt_breakdown(regs, params)
      table do 
        tr do
          th "Size"
          th "Hoodies"
          th "T-Shirts"
        end
        StudentRegistration::SIZES.each do |size|
          tr do
            td size
            td hoodies[size]
            td tshirts[size]
          end
        end
        tr do
          td "Total"
          td hoodies.values.sum
          td tshirts.values.sum
        end
      end
    end
  end

  action_item :print_pdf do
    link_to "Print Hoodies & T-Shirt List", pdf_admin_attendance_calculations_path(params.permit(q:[:h_eq, :t_eq])), method: :get, format: :pdf
  end

  csv do 
    column :last_name, :sortable =>'students.last_name' do |reg|
      reg.student.last_name.capitalize    
    end

    column :first_name, :sortable =>'students.first_name' do |reg|
      reg.student.first_name.capitalize
    end

    column "Attendances" do |reg|
      reg.attendances.present.count
    end

    column "T-Shirt Size" do |reg|
      reg.size
    end
  end

end
