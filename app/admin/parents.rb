ActiveAdmin.register Parent do
  scope 'Confirmed',:with_confirmed_registrations
  scope "Pending", :with_pending_registrations
  scope "Current", :with_current_registrations
  scope "Wait List", :with_wait_listed_registrations
  scope :all

  controller do
    def scoped_collection
      end_of_association_chain.includes(:user)
    end

    def update
       @parent = Parent.find(params[:id])
       @parent.attributes = params[:parent]
       @parent.save!(validate: false)
       redirect_to admin_parent_path(@parent), :notice => "Parent updated" 
    end
  end


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
    f.actions :commit
  end

csv do
    column :first_name  do |parent|
      parent.user.first_name.capitalize
    end

    column :last_name  do |parent|
      parent.user.last_name.capitalize
    end

    column :email do |parent|
      parent.user.email
    end
    column :primary_phone do |parent|
      parent.user.primary_phone
    end

    column :address1 do |parent|
      parent.user.address1
    end

    column :address2 do |parent|
      parent.user.address2
    end

    column :city do |parent|
      parent.user.city
    end

    column :state do |parent|
      parent.user.state
    end

    column :state do |parent|
      parent.user.zip
    end
  end
end
