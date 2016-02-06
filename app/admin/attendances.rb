ActiveAdmin.register Attendance do
  #config.clear_sidebar_sections!

  #filter :student, :collection => StudentRegistration.order("last_name asc, first_name asc")
  filter :session_date
  menu :parent => "attendance sheets"

  controller do
    def scoped_collection
      Attendance.current
    end
  end

  index do
    column :name do |f|
      f.student_registration.student.name
    end
    column :session_date
    column :attended
    default_actions
  end



  show :title =>  proc{"Attendance record for #{attendance.student_registration.student.name} for #{attendance.session_date}" } do
    attributes_table do

      row "Student " do
        attendance.student_registration.student.name
      end
      row "Date" do
        attendance.attendance_sheet.session_date
      end

      row "Attended" do
        attendance.attended ? "Yes" : "No"
      end
    end
  end



  form do |f|
    f.inputs  do
      f.input :attended
      f.input :session_date
    end
    f.buttons
  end

end
