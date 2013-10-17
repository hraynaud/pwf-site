ActiveAdmin.register Instructor do
	controller do
		def create
			@instructor = Instructor.new(params[:instructor])
			@instructor.user.is_instructor =true
			create!
		end

		def new
			@instructor = Instructor.new
			@instructor.build_user
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