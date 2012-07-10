ActiveAdmin.register StudentRegistration do

  scope :current do |registrations|
    registrations.where("season_id = ?", Season.current.id)
  end

  index do

    column :id
    column :season do |reg|
      reg.season.description
    end
    column :student
    column "Status", :status_cd
    column :grade
    column "T-Shirt Size", :size_cd
    default_actions
  end

end
