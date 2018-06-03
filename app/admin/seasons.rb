ActiveAdmin.register Season do
  menu :parent => "Admin"
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
    column :spring_registration_open
    column :status
    actions
  end
  form do |f|
    f.inputs season.description do
      f.input :beg_date
      f.input :end_date
      f.input :fall_registration_open
      f.input :spring_registration_open
      f.input :open_enrollment_date
      f.input :current
      f.input :status_cd, :as => :select, :collection => Season.statuses
      f.input :fencing_fee
      f.input :aep_fee
    end
    f.actions :commit
  end
  show :title => :description

end
