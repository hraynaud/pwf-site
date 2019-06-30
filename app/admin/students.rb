ActiveAdmin.register Student,  as: "All" do
  menu label: "All", parent: "Students", priority: 4


  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :parent, :collection => Parent.ordered_by_name

  controller do
  end

 index do

   column :first_name
   column :last_name
   column :gender
   column :dob
   column :parent, :sortable => false
   column :parent_email do |student|
     student.email
   end

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
    f.actions
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

csv do
    column :first_name  do |student|
      student.first_name
    end

    column :last_name  do |student|
      student.last_name
    end
    column "Parent Email" do |student|
      student.parent.name
    end

    column "Parent Email" do |student|
      student.parent.email
    end

    column :primary_phone do |student|
      student.primary_phone
    end

    column :address do |student|
      student.address
    end

  end

  sidebar :photo, only:[:edit, :show] do
    div do
      photo = resource.photo.attached? ? url_for(resource.photo.variant(resize: "160x160")) : image_path("user-place-holder-128x128.png")
      img src: photo
    end
  end


end
