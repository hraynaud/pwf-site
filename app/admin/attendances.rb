ActiveAdmin.register Attendance do
  #config.clear_sidebar_sections!
  belongs_to :attendance_sheet
  #menu :parent => "attendance sheets"

  filter :student, :collection => StudentRegistration.joins(:student).order("students.last_name asc, students.first_name asc")
  filter :session_date

  controller do
    def scoped_collection
      Attendance.current
    end

    def update
     binding.pry
    end
  end

  index do
    column :name do |f|
      f.student_registration.student.name
    end
    column :session_date
    column :attended
    actions
  end



  show :title =>  proc{|attendance| attendance.student_registration.student.name } do
    attributes_table do

      row "Date" do
        attendance.attendance_sheet.session_date
      end

      row "Attended" do
        attendance.attended ? "Yes" : "No"
      end
    end
  end


  form do |f|
    f.inputs f.object.student_registration.student.name  do 
      f.input :attended, :label => f.object.session_date.to_s
      #f.input :session_date 
    end
    f.actions

  end

end
