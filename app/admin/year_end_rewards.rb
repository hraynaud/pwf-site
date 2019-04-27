ActiveAdmin.register StudentRegistration,  as: "Year End Rewards" do
  includes :student, :attendances

  menu  parent: "Administration", label: "Hoodies"

  config.filters = false

  breadcrumb do
    ['admin', Season.current.description]
  end

  scope :all, default: true

  scope "Hoodies" do |regs|
    regs.where(id: Attendance.attendence_ids_with_count_greater_than( controller.hoodie_count))
  end

  scope "T-shirts" do |regs|
    regs.where(id: Attendance.attendence_ids_with_count_greater_than(controller.t_shirt_count))
  end

  controller do
    def hoodie_count 
      params.dig("q", "h_eq") || Season.current.min_attendance_count_for_hoodies
    end

    def t_shirt_count 
      params.dig("q", "t_eq") || Season.current.min_attendance_count_for_t_shirts
    end

    def scoped_collection
      StudentRegistration.current.confirmed.joins(:student)
    end
  end

  sidebar :filter do

    @hood_pct = controller.hoodie_count
    @tee_pct = controller.t_shirt_count

    form class: "filter_form", action: admin_year_end_rewards_path do

      div class: "form-element-grp inline"do
        label "Hoodies" do
          input type: "text", name: "q[h_eq]", value: @hood_pct
        end
      end

      div class: "form-element-grp inline"do
        label "T-shirts " do
          input type: "text", name: "q[t_eq]", value: @tee_pct
        end
      end

      div class: "buttons" do

        button "Filter", type: "submit"
        a "Clear Filters", class: "clear_filters_btn",  href: "#"
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
