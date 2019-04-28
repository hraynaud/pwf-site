ActiveAdmin.register StudentRegistration,  as: "Year End Rewards" do

  includes :student, :attendances

  menu  parent: "Administration", label: "Hoodies"

  config.filters = false
  config.clear_action_items!

  breadcrumb do
    ['admin', Season.current.description]
  end



  scope "Hoodies", group: :awarded do |regs|
    AttendanceAwards.hoodies regs, params
  end

  scope "T-shirts" , group: :awarded do |regs|
    AttendanceAwards.t_shirts regs, params
  end


  scope "No Award", scop: :no_award do |regs|
    AttendanceAwards.no_award regs, params
  end

  scope :all, default: true

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
        text_node " classes as of today."
      end

      para ""
      para "Set a value for  the minimum attendance % for either or both hoodies and t-shirts,  then click submit to see how the number of recipients changes."
      para "The number of attendances is calculated for the corresponding percentage value"
      para "Click reset to go back to the default value set for the season."

      form class: "filter_form", action: admin_year_end_rewards_path do

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

        div class: "buttons" do

          button "Submit", type: "submit"
          a "Reset", class: "clear_filters_btn",  href: "#"
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
