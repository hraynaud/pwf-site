ActiveAdmin.register StudentRegistration do
  filter :student,:sortable => "students.name", :collection => Student.order("last_name asc, first_name asc")
  filter :season
  filter :status

  scope :past do |registrations|
    registrations.where("season_id != ?", Season.current.id)
  end
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

  show :title =>  proc{"#{student_registration.student_name} - #{student_registration.season.description}"}
end
