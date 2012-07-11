ActiveAdmin.register Season do
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
    default_actions
  end

  show :title => :description

end
