ActiveAdmin.register Season do
  permit_params :current, :beg_date, :end_date, :fall_registration_open, :spring_registration_open, :status_cd, :created_at, :updated_at, :current, :fencing_fee, :aep_fee, :open_enrollment_date, :message

  menu :parent => "Administration", priorty: 20
  config.clear_sidebar_sections!
  scope :all
  scope :current, :default =>true do |seasons|
    today = Time.now
    seasons.where("? >= fall_registration_open and ? <= end_date",today,today)
  end

  index do
    column :name
    column :beg_date
    column :end_date
    column :fall_registration_open
    column :status
    actions
  end

  form do |f|
    f.inputs season.description do
      f.input :beg_date, as: :date_picker
      f.input :end_date, as: :date_picker
      f.input :fall_registration_open, as: :date_picker
      f.input :open_enrollment_date, as: :date_picker
      f.input :current
      f.input :status_cd, :as => :select, :collection => Season.statuses.hash
      f.input :fencing_fee
      f.input :aep_fee
    end
    f.actions
  end
  show :title => :description

end
