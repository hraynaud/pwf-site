ActiveAdmin.register Student do
  scope :all
  scope :current, :default => true
  index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent, :sortable => false
    column :currently_registered?
    default_actions
  end


  filter :first_name
  filter :last_name
  filter :parent, :collection => Parent.order("last_name asc, first_name asc")
end
