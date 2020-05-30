ActiveAdmin.register Parent do
 permit_params :first_name, :last_name, :email, :address1, :address2, :city, :state, :other_phone, :zip, :primary_phone, :secondary_phone


  scope 'Confirmed', group: :current do
    Parent.with_current_confirmed_registrations.distinct
  end
  scope "HS Seniors", group: :current do  
    Parent.with_seniors.distinct
  end

  scope "Pending", group: :current do 
    Parent.with_current_pending_registrations.distinct
  end

  scope "Wait List", group: :current do  
    Parent.with_current_wait_listed_registrations.distinct
  end

  scope 'All Attended', group: :historical do 
    Parent.with_confirmed_registrations.distinct
  end
 
  scope 'Former', group: :historical do 
    Parent.former.distinct
  end

  #scope "Previously Wait Listed",  group: :historical do 
    #Parent.with_wait_listed_registrations
  #end

  #scope "Previous", :with_previous_registrations
  scope :all, group: :historical

  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"
  filter :email_cont, label: "Email"

  index do
    column "first_name", :sortable => "users.first_name"
    column "last_name",  :sortable => "users.last_name"
    column "email", :sortable => "users.email"
    column "primary_phone", :sortable => "users.primary_phone"
    actions
  end

  show :title => :name do |parent|
    attributes_table do
      row :email
      row :full_address
      row :primary_phone
      row :secondary_phone
      row :other_phone
      row :id
    end

    panel "Students" do
      table_for(parent.students) do |t|
        t.column("Name") {|student| auto_link student  }
        t.column("Currently Registered?")   {|student| student.currently_registered? ? "Yes" : "No"}
        t.column("Status")   {|student| student.current_registration ? student.current_registration.status : "NA"}
      end

      if parent.has_current_unpaid_fencing_registrations?
        div do
          link_to "Pay Registration Fee", new_admin_payment_path(:parent_id => parent.id)
        end
      end
    end
    panel "Current Household Profile" do
      if !parent.current_household_profile.nil? 
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

  form do |f|
        f.inputs  do 
          f.input :first_name
          f.input :last_name
          f.input :email

          f.input :address1
          f.input :address2
          f.input :city
          f.input :state
          f.input :zip
          f.input :primary_phone
          f.input :secondary_phone
          f.input :other_phone
        end
    f.actions
  end

csv do
    column :first_name  do |parent|
      parent.first_name.capitalize
    end

    column :last_name  do |parent|
      parent.last_name.capitalize
    end

    column :email do |parent|
      parent.email
    end
    column :primary_phone do |parent|
      parent.primary_phone
    end

    column :address1 do |parent|
      parent.address1
    end

    column :address2 do |parent|
      parent.address2
    end

    column :city do |parent|
      parent.city
    end

    column :state do |parent|
      parent.state
    end

    column :state do |parent|
      parent.zip
    end
  end
end
