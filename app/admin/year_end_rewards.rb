ActiveAdmin.register StudentRegistration,  as: "Year End Rewards" do
  includes :student, :attendances

  menu  parent: "Administration", label: "Hoodies"

  config.filters = false

  breadcrumb do
    ['admin', Season.current.description]
  end

  scope "Hoodies" do |regs|
    regs.where(id: Attendance.attendence_ids_with_count_greater_than(11))
  end

  scope "T-shirts" do |regs|
    regs.where(id: Attendance.attendence_ids_with_count_greater_than(5))
  end

  controller do
    def scoped_collection
      StudentRegistration.current.confirmed
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
