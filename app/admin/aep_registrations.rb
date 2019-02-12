ActiveAdmin.register AepRegistration do
  menu parent: "Students"
  actions  :index, :update, :edit, :destroy, :show

  includes [student_registration: :student]


  scope :current, default: true do
    AepRegistration.current.paid
  end

  index do
    column :last_name, :sortable =>'students.last_name' do |reg|
      link_to reg.student_name.capitalize, admin_student_path(reg.student)
    end

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
