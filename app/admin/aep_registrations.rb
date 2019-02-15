ActiveAdmin.register AepRegistration do
  menu parent: "Students"
  breadcrumb do 
    ['admin', Season.find(params['q']['student_registration_season_id_eq']).description]
  end
  actions  :index, :update, :edit, :destroy, :show

  includes [student_registration: :student]

  filter :student, :collection => Student.by_last_first
  filter :season, :collection => Season.by_season

  controller do 
    def scoped_collection
      AepRegistration.paid
    end
  end


  index do
    column :last_name, :sortable =>'students.last_name' do |reg|
      link_to reg.student_name.capitalize, admin_student_path(reg.student)
    end
    column :season
    column :grade
    column :learning_disability
    column :iep

    column :student_academic_contract
    column :parent_participation_agreement
    column :transcript_test_score_release
    column :learning_disability_details
    column :iep_details
    actions
  end


end
