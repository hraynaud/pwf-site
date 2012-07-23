ActiveAdmin.register Parent do

  scope :with_current_registrations, :default => true
  scope :all

  index do
    column :first_name
    column :last_name
    column :email
    column :primary_phone
    default_actions
  end

  filter :first_name
  filter :last_name
  filter :email

  show :title => :name do |parent|
    attributes_table do
      row :name
      row :email
      row :full_address
      row :primary_phone
      row :secondary_phone
      row :other_phone
      row :id

    end

    panel "Students" do
      table_for(parent.students) do |t|
        t.column("Name") {|student| auto_link student.name        }
        t.column("Currently Registerd?")   {|student| student.currently_registered? }
      end
    end
    panel "Current Household Profile" do
      attributes_table_for parent.current_household_profile do
        row :num_minors
        row :num_adults
        row :education_level
        row :income_range
        row :home_ownership
      end
    end

  end

end
