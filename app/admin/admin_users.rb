ActiveAdmin.register AdminUser do
  menu :parent => "Admin"
  filter :email

  index do
    column :email
    actions
  end

  show :title => proc {"#{@admin_user.email}"} do |admin|
    attributes_table do
      row :email
      row :id
    end
  end

  permit_params :email, :password, :password_confirmation, :remember_me

  form do |f|
    f.inputs f.object.email do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions :commit
  end

end
