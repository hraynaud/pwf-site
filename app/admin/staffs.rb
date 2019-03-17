ActiveAdmin.register Staff do
  menu :parent => "Administration"
  permit_params :first_name, :last_name, :email, :phone_number
 
config.filters = false

  index do
    column "first_name", :sortable => "users.first_name"
    column "last_name",  :sortable => "users.last_name"
    column "email", :sortable => "users.email"
    column "primary_phone", :sortable => "users.primary_phone"
    actions
  end
end
