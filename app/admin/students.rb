ActiveAdmin.register Student do
  scope :all
  scope :current, :default => true

  filter :first_name
  filter :last_name
  filter :parent, :collection => Parent.joins(:user).order("last_name asc, first_name asc")

 index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent, :sortable => false
    column :currently_registered?
    column :registration_status
    default_actions
  end

  form do |f|
    f.inputs  do
      f.input :first_name
      f.input :last_name
      f.input :ethnicity, :collection =>Student::ETHNICITY, :input_html => {:id => "ethnic"}, :label => "Ethnicity"
      f.input :gender, :as => :select, :collection => ['M', 'F']
      f.input :dob
      f.input :parent, :collection => Parent.joins(:user).with_current_registrations.order("users.last_name asc, users.first_name asc").map{|p| [p.name, p.id]}
    end
    f.buttons :commit
  end

  show :title => :name do
    attributes_table do
    row :name
    row :gender
    row :dob
    row :parent
    row :currently_registered?

    end

    panel "Registration History" do
      table_for(student.student_registrations) do |t|
          t.column("Season")   {|reg| link_to reg.season.description, admin_student_registration_path(reg)}
      end
    end
  end



end
