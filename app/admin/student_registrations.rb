ActiveAdmin.register StudentRegistration do
  filter :student, :collection => Student.order("last_name asc, first_name asc")
  filter :season
  filter :status

  scope :past do |registrations|
    registrations.where("season_id != ?", Season.current.id)
  end

  scope :current, :default => true do |registrations|
    registrations.where("season_id = ?", Season.current.id)
  end

  scope :pending, :default => true do |registrations|
    registrations.where("season_id = ? and status_cd = #{StudentRegistration.statuses['Pending']}", Season.current.id)
  end

  scope :paid, :default => true do |registrations|
    registrations.where("season_id = ? and status_cd = #{StudentRegistration.statuses['Confirmed Paid']}", Season.current.id)
  end

  scope :wait_list do |registrations|
    registrations.where("season_id = ? and status_cd = #{StudentRegistration.statuses['Wait List']}", Season.current.id)
  end

  index do
    column :student
    column :season do |reg|
      reg.season.description
    end
    column "Status", :status_cd do |reg|
      reg.status
    end
    column :grade
    column "T-Shirt Size", :size_cd do |reg|
      reg.size
    end
    column :id
    column :created_at
    default_actions
  end

  show :title =>  proc{"#{student_registration.student_name} - #{student_registration.season.description}"} do
    attributes_table do
      row :grade
      row :school
      row :status do
        student_registration.status
      end
      row :size_cd do
        student_registration.size
      end
      row :academic_notes
      row :medical_notes
      row :academic_assistance do
        student_registration.academic_assistance ? "Yes" : "No"
      end

      row :parent do
        student_registration.student.parent
      end
      row :created_at
    end
  end

  form do |f|
    f.inputs "#{student_registration.student_name} - #{student_registration.season.description}" do
      f.input :school
      f.input :grade, :as => :select, :collection => 4..16
      f.input :status_cd, :as => :select, :collection => StudentRegistration.statuses
      f.input :size_cd, :as => :select, :collection => StudentRegistration.sizes
      f.input :academic_notes
      f.input :medical_notes
      f.buttons :commit
    end
  end


end
