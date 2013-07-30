require 'spec_helper'

feature "Signup process" do

  scenario "New parent sign up with valid login" do
    visit(root_path)
    click_link "new_registration"

    current_path.should==new_user_registration_path
    fill_in "parent_user_attributes_email", :with =>"herby@herby.com"
    fill_in "parent_user_attributes_password", :with => "testme"
    fill_in "parent_user_attributes_password_confirmation", :with => "testme"
    click_button "Continue"
    page.should have_selector "#personal"
    page.should have_selector "#contact_details"
    page.should have_button "Continue"
    page.should have_button "Back"
    User.count.should == 0
    fill_in "parent_user_attributes_first_name", :with =>"Gandalf"
    fill_in "parent_user_attributes_last_name", :with => "Wizard"
    fill_in "parent_user_attributes_primary_phone", :with => "555-321-7654"
    fill_in "parent_user_attributes_address1", :with =>"123 Main Street"
    fill_in "parent_user_attributes_address2", :with => "1A"
    fill_in "parent_user_attributes_city", :with => "Anywhere"
    select  "New York", :from =>  "parent_user_attributes_state"
    fill_in "parent_user_attributes_zip", :with => "11223"
    click_button "Continue"
    page.should have_selector "#household_details"
    fill_in "num_adults", :with =>"1"
    fill_in "num_minors", :with => "2"
    choose  "25,000-49,999"
    choose  "High school"
    choose  "Own"
    click_button "Continue"
    current_path.should == parent_path(User.find_by_email("herby@herby.com").profileable)
  end

  scenario "New parent registers invalid login info" do
    visit(root_path)
    click_link "new_registration"
    fill_in "parent_user_attributes_email", :with =>"herby@herby.com"
    fill_in "parent_user_attributes_password", :with => "testme"
    click_button "Continue"
    fill_in "parent_user_attributes_password", :with => "testme"
    fill_in "parent_user_attributes_password_confirmation", :with => "testme"
    click_button "Continue"
    save_and_open_page
    page.should have_selector "#personal"
    page.should have_selector "#contact_details"
    page.should have_button "Continue"
    page.should have_button "Back"
    Parent.count.should == 0
    fill_in "parent_user_attributes_first_name", :with =>"Gandalf"
    fill_in "parent_user_attributes_last_name", :with => "Wizard"

    fill_in "parent_user_attributes_address1", :with =>"123 Main Street"
    fill_in "parent_user_attributes_address2", :with => "1A"
    fill_in "parent_user_attributes_city", :with => "Anywhere"
    select  "New York", :from =>  "parent_user_attributes_state"
    fill_in "parent_user_attributes_zip", :with => "11223"
    click_button "Continue"
    current_path.should==parents_path
    fill_in "parent_user_attributes_primary_phone", :with => "555-321-7654"
    click_button "Continue"
    page.should have_selector "#household_details"
    fill_in "num_adults", :with =>"1"
    choose  "25,000-49,999"
    choose  "High school"
    choose  "Own"
    click_button "Continue"
    current_path.should==parents_path
    fill_in "num_minors", :with => "2"
    fill_in "num_adults", :with =>"1"
    click_button "Continue"
    current_path.should == new_user_registration_path(User.find_by_email "herby@herby.com").profileable
  end

  scenario "New parent cannot register unless open enrollment" do
    disable_open_enrollment
    visit(root_path)
    page.should_not have_link("new_registration")
  end

  scenario "New parent cannot register unless open enrollment", :focus=>:failing do
    disable_open_enrollment
    visit new_user_registration_path
    current_path.should == root_path
    page.should have_content "Open Enrollement for new registrations opens on"
  end
end
