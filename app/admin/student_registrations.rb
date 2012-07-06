ActiveAdmin.register StudentRegistration do
  index do

    column :id
    column :season do |reg|
      reg.season.description
    end
    column :student
    column "Status", :status_cd
    column :grade
    column "T-Shirt Size", :size_cd
  end

end
