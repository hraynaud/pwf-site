ActiveAdmin.register Manager do

  scope :all


  filter :first_name
  filter :last_name
  filter :email

  controller do
    def create
      @manager = Manager.new(params[:manager])
      @manager.user.is_mgr =true
      create!
    end

    def new
      @manager = Manager.new
      @manager.build_user
    end
  end




  index do
    column :first_name
    column :last_name
    column :email
    column :primary_phone
    default_actions
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
  end


  form do |f|
    #f.inputs :name => "New Manager" do
    f.inputs :for => :user do |u|
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
      u.input :password
      u.input :password_confirmation
      #u.input :is_mgr, :value => true, :as => :hidden
    end
    #end
    f.buttons :commit
  end

end
