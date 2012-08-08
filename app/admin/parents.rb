ActiveAdmin.register Parent do

  scope :with_current_registrations, :default => true
  scope :all

  scope :with_pending_registrations do |parents|
    parents.with_current_registrations.pending
  end

  scope :with_paid_registrations do |parents|
    parents.with_current_registrations.paid
  end

  filter :first_name
  filter :last_name
  filter :email


  index do
    column :first_name
    column :last_name
    column :email
    column :primary_phone
    default_actions
  end
  show :title => proc {"#{@parent.name}"} do |parent|
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
      attributes_table_for parent.current_household_profile do
        row :num_minors
        row :num_adults
        row :education_level
        row :income_range
        row :home_ownership
      end
    end
  end

  form do |f|
    f.inputs f.object.name do

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
    f.buttons :commit
  end

end
