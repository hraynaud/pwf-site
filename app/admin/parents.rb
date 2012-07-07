ActiveAdmin.register Parent do

  scope :all
  scope :with_current_registrations, :default => true

   index do
    column :first_name
    column :last_name
    column :email
    column :primary_phone
    default_actions
  end
  show :title => :name do |parent|
    attributes_table do
      row :name
      row :email
      row :full_address
      row :primary_phone
      row :secondary_phone
      row :other_phone
    end
    panel "Students" do
      table_for(parent.students) do |t|
        t.column("Name") {|student| auto_link student.name        }
        t.column("Currently Registerd?")   {|student| student.currently_registered? }
      end
    end
  end

end
