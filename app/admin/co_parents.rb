ActiveAdmin.register CoParent do
 permit_params :first_name, :last_name, :email, :address1, :address2, :city, :state, :other_phone, :zip, :primary_phone, :secondary_phone
  menu :parent => "Parents"
  scope :all
  scope "Current", :with_current_registrations

  filter :first_name_cont, label: "First Name"
  filter :last_name_cont, label: "Last Name"

  controller do

    def update
       @co_parent = CoParent.find(params[:id])
       @co_parent.attributes = params[:co_co_parent]
       @co_parent.save!(validate: false)
       redirect_to admin_co_parent_path(@co_parent), :notice => "Parent updated" 
    end
  end


  index do
    column "first_name", :sortable => "users.first_name"
    column "last_name",  :sortable => "users.last_name"
    column "email", :sortable => "users.email"
    column "primary_phone", :sortable => "users.primary_phone"
    actions
  end

  show :title => :name do |co_parent|
    attributes_table do
      row :email
      row :full_address
      row :primary_phone
      row :secondary_phone
      row :other_phone
      row :id
    end

    panel "Students" do
      table_for(co_parent.students) do |t|
        t.column("Name") {|student| auto_link student  }
        t.column("Currently Registered?")   {|student| student.currently_registered? ? "Yes" : "No"}
        t.column("Status")   {|student| student.current_registration ? student.current_registration.status : "NA"}
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
    column :first_name  do |co_parent|
      co_parent.user.first_name.capitalize
    end

    column :last_name  do |co_parent|
      co_parent.user.last_name.capitalize
    end

    column :email do |co_parent|
      co_parent.user.email
    end
    column :primary_phone do |co_parent|
      co_parent.user.primary_phone
    end

    column :address1 do |co_parent|
      co_parent.user.address1
    end

    column :address2 do |co_parent|
      co_parent.user.address2
    end

    column :city do |co_parent|
      co_parent.user.city
    end

    column :state do |co_parent|
      co_parent.user.state
    end

    column :state do |co_parent|
      co_parent.user.zip
    end
  end
end
