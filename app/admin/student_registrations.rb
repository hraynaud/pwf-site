ActiveAdmin.register StudentRegistration do
  actions  :index, :update, :edit, :destroy, :show

  includes :attendances 
  permit_params  :school, :grade, :status_cd, :size_cd, :academic_notes, :medical_notes, :report_card_exempt
  menu false
 breadcrumb do
    ['admin', Season.current.description]
  end
  filter :student, :collection => Student.by_last_first

  scope "Enrolled", :current_confirmed, default: true

  scope "Pending", :current_pending 
  scope "Wait Listed", :current_wait_listed
  scope "Withdrawn", :current_withdrawn

  member_action :attendance, method: [:get,:put, :post] do

    if request.get?
      render json: resource.ytd_attendance
    elsif request.post?
      resource.attendances.create({attendance_sheet_id: params["sheet_id"], attended: true})
      render json: resource.ytd_attendance
    else
      attendance = resource.attendances.find(params["attendance_id"])
      attendance.attended = params["attended"]
      attendance.save
      render json: resource.ytd_attendance
    end
  end

  controller do

    def attendance_link status 
      case status
      when 'present'
        "mark absent"
      when 'absent'
        "mark present"
      else 
        "create"
      end
    end

    def current_season
      @current_season ||= 
        begin
          if params["q"]
            params["q"]["season_id_eq"]
          else
            Season.current.id
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

    column "Status", :status_cd do |reg|
      reg.status
    end
    column :grade
    column "T-Shirt Size", :size_cd do |reg|
      reg.size
    end
    column :id
    column :created_at
    actions
  end

  show :title =>  proc{"#{@student_registration.student_name} - #{@student_registration.season.description}"} do
    attributes_table do
      row :name do
        link_to student_registration.student_name, admin_student_path(student_registration.student)
      end
      row :grade
      row :school
      row :status do
        student_registration.status
      end
      row :size_cd do
        student_registration.size
      end

      row "Enrolled in AEP" do |reg|
        reg.enrolled_in_aep?
      end

      row :academic_notes
      row :medical_notes
      row :academic_assistance do
        student_registration.academic_assistance ? "Yes" : "No"
      end

      row :parent do
        student_registration.student.parent
      end
      row :created_at
    end
  end

  sidebar :attendance,  only: :edit do

    div class: "season-attendance",  id: "vue-app-container", 
      "data-load-path": attendance_admin_student_registration_path(resource) do
      div id: "attendance-app" 
    end

  end

  form do |f|
    f.inputs "#{student_registration.student_name} - #{student_registration.season.description}" do
      f.input :school
      f.input :grade, :as => :select, :collection => 4..16
      f.input :status_cd, :as => :select, :collection => StudentRegistration.status_options, label: 'Status'
      f.input :size_cd, :as => :select, :collection => StudentRegistration.size_options, label: 'Size'
      f.input :academic_notes
      f.input :medical_notes
      f.input :report_card_exempt

    f.actions
    end

  end

  csv do
    column :first_name  do |reg|
      reg.student.first_name.capitalize
    end

    column :last_name  do |reg|
      reg.student.last_name.capitalize
    end

    column :parent  do |reg|
      reg.student.parent.name.titleize
    end

    column :season do |reg|
      reg.season_description
    end
    column :status_cd do |reg|
      reg.status
    end
    column :grade
    column :size_cd do |reg|
      reg.size
    end
    column :id
    column :created_at
  end

end
