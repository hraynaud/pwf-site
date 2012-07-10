module StepHelpers
  def do_login(user)
    visit(login_path)
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => user.password)
    click_button('Sign in')
  end

  def change_password(pwd)
    fill_in "current_password", :with=> pwd
    fill_in "password", :with=> "testme"
    fill_in "password_confirmation", :with=> "testme"
    save_changes("password")
  end

  def do_fillin_parent_info(info = {})
    fill_in "parent_address1", :with => info[:address1] || "123 Main Street"
    fill_in "parent_address2", :with => info[:address2] || "1A"
    fill_in "parent_city", :with => info[:city] || "Anywhere"
    select  "New York", :from =>  info[:state] || "parent_state"
    fill_in "parent_zip", :with => info[:zip] || "11223"
    fill_in "parent_primary_phone", :with => info[:phone] || "555-321-7654"
    fill_in "parent_demographics_attributes_num_adults", :with => info[:num_adults] || "1"
    fill_in "parent_demographics_attributes_num_minors", :with => info[:num_minors] || "2"
    choose  "25,000-49,999"
    choose  "High school"
    choose  "Own"
  end

  def do_logout
    click_link "Log out"
  end

  def setup_state
    setup_user
  end

  def setup_user
    @state[:user]=FactoryGirl.create(:user)
  end


  def do_new_student_registration(first_name = nil)
    _student_main_fields(first_name)
    _student_birthdate_fields
  end

  def do_new_student_registraion_incomplete
    _student_main_fields
  end

  def _student_main_fields(first_name =nil)
    fill_in "first_name", :with => first_name || "herby"
    fill_in "last_name", :with => "The Dude"
    choose  "Male"
    fill_in "school", :with => "Hard Knocks"
    fill_in "grade", :with => "4"
    select  "M", :from => "Size"
  end

  def _student_birthdate_fields
    select "January", :from => "student_dob_2i"
    select "1", :from => "student_dob_3i"
    select "1992", :from => "student_dob_1i"
  end

end

