ActiveAdmin.register StudentRegistration,  as: "Attendance Calculation" do

  includes :student, :attendances

  menu  parent: "Administration", label: "Attendance Calculation"
  config.filters = false
  config.clear_action_items!

  breadcrumb do
    ['admin', Season.current.description]
  end

   scope "Hoodies & T-shirts", group: :awarded  do |regs|
    controller.hoodie_students
  end

  scope "T-shirts Only", group: :awarded do |regs|
    controller.t_shirt_students
  end

  scope "No Award", group: :no_award do |regs|
    controller.no_award_students
  end

  scope :all, default: true

  def self.blah
   "blah blah"
  end

  controller do
    def scoped_collection
      StudentRegistration.current.confirmed.joins(:student)
    end

    def hoodie_students 
      attendance_awarder.hoodies
    end

    def t_shirt_students 
      attendance_awarder.t_shirts
    end

    def no_award_students 
      attendance_awarder.no_award
    end

    def extract_params key
      params.dig("q", key) ? params.dig("q", key).to_f : nil
    end

    def attendance_awarder
      @awarder ||= AttendanceAwards.new(extract_params('h_eq'), extract_params('t_eq'))
    end
  end

  collection_action :pdf, method: :get do
    disp = params[:disposition].present? ? params[:disposition] : "attachment"
    pdf = AttendanceAwardSheetPdf.new(attendance_awarder)
    send_data pdf.render , filename: "hoodies_list.pdf", type: "application/pdf", disposition: disp
  end

  index download_links: -> { [:csv]  }  do
 
    column :last_name, :sortable =>'students.last_name' do |reg|
      link_to reg.student.last_name.capitalize, admin_student_path(reg.student) end
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
          label "Hoodies % (#{controller.attendance_awarder.hoodie_count} attendances)" do
            input type: "text", name: "q[h_eq]", value: controller.attendance_awarder.hoodie_pct
          end
        end

        div class: "form-element-grp inline"do
          label "T-shirts % ( #{controller.attendance_awarder.t_shirt_count} attendances)" do
            input type: "text", name: "q[t_eq]", value: controller.attendance_awarder.t_shirt_pct
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
      hoodies = controller.attendance_awarder.hoodies_breakdown
      tshirts = controller.attendance_awarder.t_shirt_breakdown
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

  action_item do
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
