ActiveAdmin.register Payment do
  scope :all
  scope :current do
    payments.joins(:student_registrations).where("student_registrations.season_id = ?", Season.current.id)
  end

  filter :parent, :collection => Parent.order("last_name asc, first_name asc").where("first_name is not null")

  index do
    column :parent
    column "season" do |p|
        p.student_registrations.first.season.description
    end
    column :amount
    column :created_at
    default_actions
  end

  show :title => proc {"Payment for: #{@payment.payments_for}"} do |payment|
    attributes_table do
      row :parent
      row "Season" do
        payment.student_registrations.first.season.description
      end
      row :amount
      row "Method" do

      end
      row :id
      row :created_at
    end

    panel "Paid Registrations" do
      table_for(payment.student_registrations) do |t|
        t.column("Student") {|student_registration| link_to student_registration.student_name, admin_student_registration_path(student_registration)  }
      end
    end
  end


  form do |f|
    f.inputs f.object.payments_for do

    end
    f.buttons :commit
  end

end
