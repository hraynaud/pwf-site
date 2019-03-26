ActiveAdmin.register Staff do
  menu :parent => "Administration", label: "Staff"
  permit_params :first_name, :last_name, :email, :phone_number
 
config.filters = false

  index do
    column "first_name", :sortable => "staffs.first_name"
    column "last_name",  :sortable => "staffs.last_name"
    column "email", :sortable => "staffs.email"
    column "primary_phone", :sortable => "staffs.primary_phone"
    actions
  end
end
