module StepHelpers
  def do_login(user, password="testme")
    pwd = user.password || password
    visit root_path
    click_link "Login"
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => pwd)
    click_button('Sign in')
  end

  def do_logout(user)
    click_link('Log out')
  end

  def do_set_season_status(status="pending")
    season = Season.current
    season.send("#{status}!") 
    season.save
  end

  def change_password(pwd)
    fill_in "current_password", :with=> pwd
    fill_in "password", :with=> "testme"
    fill_in "password_confirmation", :with=> "testme"
    save_changes("password")
  end

  def do_create_new_student
    click_link "Students"
    click_link "New Student"
    do_new_student_registration("Herby")
    click_button "submit"
  end

  def do_fillin_parent_info(info = {})
    fillin_user_fields "parent", info
    fill_in "num_adults", :with => info[:num_adults] || "1"
    fill_in "num_minors", :with => info[:num_minors] || "2"
    choose  "25,000-49,999"
    choose  "High school"
    choose  "Own"
  end

  def fillin_user_fields(type, info={})
    info = DEFAULT_USER_INFO.merge(info)
    fill_in "#{type}_user_attributes_email", :with => info["email"]
    fill_in "#{type}_user_attributes_first_name", :with => info["first_name"]
    fill_in "#{type}_user_attributes_last_name", :with => info["last_name"]
    fill_in "#{type}_user_attributes_address1", :with => info["address1"]
    fill_in "#{type}_user_attributes_address2", :with => info["address2"]
    fill_in "#{type}_user_attributes_city", :with => info["city"]
    select  "New York", :from =>  "#{type}_user_attributes_state"
    fill_in "#{type}_user_attributes_zip", :with => info["zip"]
    fill_in "#{type}_user_attributes_primary_phone", :with => info["primary_phone"]
  end

  def disable_open_enrollment
    allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(false)
  end

  def close_season
    allow(StudentRegistrationAuthorizer).to receive(:registration_closed?).and_return(OpenStruct.new(response: true, message: "Closed"))
  end

  def do_logout
    click_link "Log out"
  end

  def setup_state
    setup_user
  end

  def setup_user
    @state[:user]=FactoryBot.create(:user)
  end

  def do_fillin_registration_fields
    _student_registration_fields
    click_button "Submit"
  end

  def do_new_student_registration(first_name = nil)
    click_link "Bio"
    _student_main_fields(first_name)
    click_link Season.current.description
   _student_registration_fields 
  end

  def do_new_student_registraion_incomplete
    click_link "Bio"
    _student_main_fields
  end

  def _student_main_fields(first_name =nil)
    fill_in "first_name", :with => first_name || "herby"
    fill_in "last_name", :with => "The Dude"
    choose  "Male" 
    select "African American", from: "Ethnicity"
    _student_birthdate_fields
  end

  def _student_birthdate_fields
    select "January", :from => "student_dob_2i"
    select "1", :from => "student_dob_3i"
    select 8.years.ago.year.to_s, from: "student_dob_1i"
  end

  def _student_registration_fields
    fill_in "School", :with => "Hard Knocks"
    fill_in "Grade", :with => "4"
    select  "L", :from => "Size"
  end

  def do_pay_with_card
    fill_in "payment_email", :with => "test_buyer@buyer.com"
    fill_in "payment_first_name", :with => "Test"
    fill_in "payment_last_name", :with => "Buyer"
    fill_in "card_number", :with => "4242424242424242"
    fill_in "card_code", :with => "123"
    fill_in "Month", with: "12"
    fill_in "Year", with: 2.years.from_now.year

    fill_in "Address", with: "123 Main Street"
    fill_in "City", with: "West BubbleF"
    fill_in  "State", with: "New York"
    fill_in "Zip", with: "12345"
    click_button "Submit Payment"
  end

  def do_pay_with_paypal
    choose "payment_pay_with_paypal"
    click_button "pay"
  end


  def accept_popup
    page.driver.browser.switch_to.alert.accept
  end

  def cancel_popup
    page.driver.browser.switch_to.alert.dismiss
  end

  def save_it
    click_button "save"
  end

  def assert_report_saved
    asserts_successful_submission
  end

  def assert_errors
    page.should have_content "can't be blank"
  end

  def assert_report_finalized
    page.should have_content "Report successfully confirmed and finalized"
  end

  def confirm_students
    parent.unpaid_registrations.each do|reg|
      reg.status = :confirmed_paid
      reg.save
    end
  end


  def asserts_successful_submission
    page.should have_content("successfully")
  end

  DEFAULT_USER_INFO= {
    "email"=>"foo8@example.com",
    "first_name"=>"tutor_foo2",
    "last_name"=>"bar8",
    "primary_phone"=>"555-123-4567",
    "address1"=>"123 Main Street",
    "city"=>"Anywhere",
    "state"=>"New York",
    "zip"=>"11234",
  }
end

def select_from_chosen(id, srch_text)
  find(:css, "##{id}").click()
  within("div##{id} ul.chosen-results") do
   find("li.active-result", :text => srch_text).click()
  end
end
