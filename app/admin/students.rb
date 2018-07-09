ActiveAdmin.register Student do
  scope :current, default: true
  scope :all

  includes :parent, student_registrations: :season

  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :parent, :collection => Parent.order("last_name asc, first_name asc")

 index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent, :sortable => false
    # This needs to be a left outer joined somehow 
    # column :currently_registered
    actions
  end

  form do |f|
    f.inputs  do
      f.input :first_name
      f.input :last_name
      f.input :ethnicity, :collection =>Student::ETHNICITY, :input_html => {:id => "ethnic"}, :label => "Ethnicity"
      f.input :gender, :as => :select, :collection => ['M', 'F']
      f.input :dob, as: :date_picker, end_year: Date.today.year-7, start_year: Date.today.year-40
      f.input :parent, :collection => Parent.with_current_registrations.ordered_by_name.map{|p| [p.name.titleize, p.id]}
    end
    f.actions :commit
  end

  show :title => :name do
    attributes_table do
    row :name
    row :gender
    row :dob
    row :parent
    row :currently_registered?
    row :registration_status

    end

    panel "Registration History" do
      table_for(student.student_registrations) do |t|
          t.column("Season")   {|reg| link_to reg.season.description, admin_student_registration_path(reg)}
      end
    end
  end



end
