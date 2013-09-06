ActiveAdmin.register Attendance do
  config.clear_sidebar_sections!

menu :parent => "attendance sheets"

  controller do
    def scoped_collection
      end_of_association_chain.joins(:student_registration)
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
      f.input :student_registration, as: :select, collection: StudentRegistration.current.joins(:student).paid.order("last_name asc, first_name asc").map{|i| [i.student.name, i.id]}
      f.input :session_date, :end_year => Time.now.year+1, :start_year => Time.now.year-1, :include_blank => true
    end
    f.buttons
  end

end
