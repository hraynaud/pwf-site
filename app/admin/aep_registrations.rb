ActiveAdmin.register AepRegistration do
  menu parent: "Students"

  actions  :index, :update, :edit, :destroy, :show

  includes [student_registration: :student]

  scope :paid
  scope :unpaid

  filter :student, :collection => Student.by_last_first
  filter :season, :collection => Season.by_season

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

  form do |f|
    f.inputs "#{aep_registration.student_name} - #{aep_registration.season.description}" do
      f.input :grade

      f.input :learning_disability
      f.input :iep

      f.input :student_academic_contract
      f.input :parent_participation_agreement
      f.input :transcript_test_score_release
      f.input :learning_disability_details
      f.input :iep_details
      
      f.input :payment_status, :collection =>AepRegistration::STATUS_VALUES, :input_html => {:id => "status"}, :label => "Paymment Status"
    f.actions
    end

  end

end
