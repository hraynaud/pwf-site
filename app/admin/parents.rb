ActiveAdmin.register Parent do
  index do
    column :first_name
    column :last_name
    column :email
    column :primary_phone
    column :students do "parent"
    link_to students_path(parent)
    end
  end


  collection_action :students, :method => :get do |parent|
    # Do some CSV importing work here...
    @students = parent.students

  end

end
