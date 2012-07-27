ActiveAdmin.register Student do
  scope :all
  scope :current, :default => true

  filter :first_name
  filter :last_name
  filter :parent, :collection => Parent.order("last_name asc, first_name asc")

 index do
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :parent, :sortable => false
    column :currently_registered?
    default_actions
  end

  form do |f|
    f.inputs "#{student.name}" do
      f.input :first_name
      f.input :last_name
      f.input :gender, :as => :select, :collection => ['M', 'F']
      f.input :dob
      f.input :parent
    end
    f.buttons :commit
  end

  show :title => proc{"#{student.name}"}do
    attributes_table do
    row :name
    row :gender
    row :dob
    row :parent
    row :currently_registered?

    end
  end



end
