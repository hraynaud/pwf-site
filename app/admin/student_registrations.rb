ActiveAdmin.register StudentRegistration do
  menu label: "Registration History", parent: "Students", priority: 1
  breadcrumb do
    ['admin', 'Student Registrations' ]
  end
  permit_params  :school, :grade, :status_cd, :size_cd, :academic_notes, :medical_notes, :report_card_exempt

  includes :parent, :student, :aep_registration, :season

  scope "Enrolled", :confirmed, group: :main, default: true
  scope :in_aep, group: :main
  scope "Seniors", :hs_seniors, group: :main

  scope :pending, group: :status
  scope :blocked_on_report_card, group: :status
  scope :wait_listed, group: :status
  scope :withdrawn, group: :status

  filter :season, collection: Season.by_season, include_blank: false
  filter :student_first_name_cont, label: "First Name"
  filter :student_last_name_cont, label: "Last Name"
  filter :parent, :collection => Parent.ordered_by_name

  controller do
    before_action only: :index do
      # when arriving through top navigation

      if(params['q'] && params['q']['season_id_eq'])
        @season = Season.find(params['q']["season_id_eq"])
      else
        @season = Season.current
      end
    end

    def scoped_collection
      end_of_association_chain.where(season_id: @season.id)
    end

  end

  index title: ->{@season.description} do

    column "First Name", :student_first_name 
    column "Last Name", :student_last_name 
    column :parent, :sortable => false
    column "Parent Email", :parent_email
    column "AEP Info" do |reg|
      reg.aep_registration.present? ? link_to("AEP Record", admin_aep_registration_path(reg.aep_registration)) : "Not Enrolled"
    end
    column :size 
    actions
  end

  show :title =>  proc{"#{@student_registration.student_name} - #{@student_registration.season.description}"} do
    attributes_table do
      row :name do |reg|
        link_to reg.student_name, admin_student_path(reg.student)
      end
      row :grade
      row :school
      row :status
      row :size

      row "Enrolled in AEP" do |reg|
        reg.enrolled_in_aep?
      end

      row :academic_notes
      row :medical_notes
      row :academic_assistance
      row :parent 
      row :created_at
    end

    panel "Report Cards Submitted" do
      table_for(student_registration.report_cards) do |t|
        t.column("Report Cards")   {|card| link_to card.description, admin_report_card_path(card)}
      end
    end

  end



  form do |f|
    f.inputs "#{student_registration.student_name} - #{student_registration.season.description}" do
      f.input :school
      f.input :grade, :as => :select, :collection => 4..16
      f.input :status_cd, :as => :select, :collection => StudentRegistration.status_options, label: 'Status'
      f.input :size_cd, :as => :select, :collection => StudentRegistration.size_options, label: 'Size'
      f.input :season, :as => :select, :collection => Season.all, label: 'Season'
      f.input :academic_notes
      f.input :medical_notes
      f.input :report_card_exempt

      f.actions
    end

  end

  csv do
    column :first_name  do |reg|
      reg.student_first_name.capitalize
    end

    column :last_name  do |reg|
      reg.student_last_name.capitalize
    end

    column :parent  do |reg|
      reg.parent.name.titleize
    end

    column :season do |reg|
      reg.season_description
    end

    column :status_cd do |reg|
      reg.status
    end

    column :grade

    column :age do |reg|
      reg.age
    end

    column :ethnicity do |reg|
      reg.student_ethnicity
    end

    column :size_cd do |reg|
      reg.size
    end
    column :id
    column :created_at
  end

  #sidebar :photo, only:[:edit, :show] do
  #div do
  #photo = resource.photo.attached? ? url_for(resource.photo.variant(resize: "160x160")) : image_path("user-place-holder-128x128.png")
  #img src: photo
  #end
  #end


end
