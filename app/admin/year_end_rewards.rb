ActiveAdmin.register StudentRegistration,  as: "Year End Rewards" do

  includes :student, :attendances

  menu  parent: "Administration", label: "Hoodies"

  config.filters = false

  breadcrumb do
    ['admin', Season.current.description]
  end

  scope :all, default: true

  scope "Hoodies" do |regs|
    AttendanceAwards.hoodies regs, params
  end

  scope "T-shirts" do |regs|
    AttendanceAwards.t_shirts regs, params
  end

  controller do
     def scoped_collection
      StudentRegistration.current.confirmed.joins(:student)
    end
  end


  sidebar "Attendance Percentage Tester" do
    div do
      div class: "inline" do 
        text_node "There have been"
        h4 class: "inline" do Season.current.num_sessions end
        text_node " classes as of today"
      end

      para ""
      para "Experiment with the minimum attendance for each award to see the number of recipients changes"

      form class: "filter_form", action: admin_year_end_rewards_path do

        div class: "form-element-grp inline"do
          label "Hoodies" do
            input type: "text", name: "q[h_eq]", value:AttendanceAwards.hoodie_pct(params)
          end
        end

        div class: "form-element-grp inline"do
          label "T-shirts " do
            input type: "text", name: "q[t_eq]", value: AttendanceAwards.t_shirt_pct(params)
          end
        end

        div class: "buttons" do

          button "Filter", type: "submit"
          a "Clear Filters", class: "clear_filters_btn",  href: "#"
        end
      end
    end
  end



  index do
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

end
