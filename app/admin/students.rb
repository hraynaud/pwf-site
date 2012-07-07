ActiveAdmin.register Student do
  scope :all
  scope :current
  index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent
    column :currently_registered?
  end
end
