ActiveAdmin.register Student do
  menu priority: 1
  includes :student_registrations
  includes :parent, student_registrations: :season

  scope "Total", :enrolled, group: :main, default: true
  scope :in_aep, group: :main

  scope :pending, group: :status
  scope :wait_listed, group: :status
  scope :withdrawn, group: :status

  filter :seasons, collection: Season.by_season
  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :parent, :collection => Parent.ordered_by_name

  controller do
    before_action only: :index do
      # when arriving through top navigation
      if params.keys == ["controller", "action"]
        extra_params = {"q" => {"student_registrations_season_id_eq" => Season.current.id}}

        # make sure data is filtered and filters show correctly
        params.merge! extra_params

        # make sure downloads and scopes use the default filter
        request.query_parameters.merge! extra_params
      end
    end
  end

 index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent, :sortable => false
    column :size do|student|
      student.registration_by_season(params['q']["student_registrations_season_id_eq"]).size 
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

  sidebar :photo, only:[:edit, :show] do
    div do
      photo = resource.photo.attached? ? url_for(resource.photo.variant(resize: "160x160")) : image_path("user-place-holder-128x128.png")
      img src: photo
    end
  end


end
