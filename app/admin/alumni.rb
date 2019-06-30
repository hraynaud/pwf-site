ActiveAdmin.register Student, as: "Alumni" do
  menu parent: "Students", label: "Alumni", priority: 3
  includes :student_registrations

  breadcrumb do
    ['admin', 'Alumni']
  end

  controller do

    def scoped_collection 
      Student.enrolled
    end

    def find_collection(options = {})
      if params[:order] == 'age_desc'
        super.reorder(dob: :asc)
      elsif params[:order] == 'age_asc'
        super.reorder(dob: :desc)
      else
        super
      end
    end

  end

  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :parent, :collection => Parent.ordered_by_name


  index do

    def get_reg(student, season)
      student.registration_by_season(season)
    end

    column :first_name
    column :last_name
    column :gender
    column :dob
    column :age, sortable: true
    column :parent, :sortable => false
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
