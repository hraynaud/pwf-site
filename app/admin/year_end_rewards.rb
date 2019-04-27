ActiveAdmin.register StudentRegistration,  as: "Year End Rewards" do
  actions  :index, :update, :edit, :destroy, :show

  includes :attendances 

  menu  parent: "Administration", label: "Hoodies"

  breadcrumb do
    ['admin', Season.current.description]
  end

  filter :student, :collection => Student.by_last_first

  controller do
   
    def scoped_collection
      StudentRegistration.current.confirmed
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

    column :grade
    column "T-Shirt Size", :size_cd do |reg|
      reg.size
    end

    actions
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
