ActiveAdmin.register Parent do

  scope :with_paid_registrations, :default => true do |parents|
    parents.with_current_registrations.paid
  end

  scope :with_pending_registrations do |parents|
    parents.with_current_registrations.pending
  end

  scope :with_current_registrations

  scope :all

  controller do
    def scoped_collection
      end_of_association_chain.includes(:user)
    end
  end


  index do
    column "first_name", :sortable => "users.first_name"
    column "last_name",  :sortable => "users.last_name"
    column "email", :sortable => "users.email"
    column "primary_phone", :sortable => "users.primary_phone"
    default_actions
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
      if parent.has_unpaid_pending_registrations?
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
        f.inputs f.object.name, :for => [:user, f.object.user] do |u|
          u.input :first_name
          u.input :last_name
          u.input :email

          u.input :address1
          u.input :address2
          u.input :city
          u.input :state
          u.input :zip
          u.input :primary_phone
          u.input :secondary_phone
          u.input :other_phone
        end
    f.buttons :commit
  end

end
