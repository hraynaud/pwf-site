require 'spec_helper'

feature "Signup process" do

  scenario "New parent sign up with valid login" do
    visit(root_path)
    click_link "new_registration"
    current_path.should==new_parent_registration_path
    fill_in "parent_email", :with =>"herby@herby.com"
    fill_in "parent_password", :with => "testme"
    fill_in "parent_password_confirmation", :with => "testme"
    click_button "submit_registration"
    parent = Parent.find_by_email("herby@herby.com")
    current_path.should == edit_parent_path(parent)
    parent.registration_complete?.should be_false
  end

  scenario "New parent signs with invalid login info" do
    visit(root_path)
    click_link "new_registration"
    current_path.should==new_parent_registration_path
    fill_in "parent_email", :with =>"herby@herby"
    fill_in "parent_password", :with => "testme"
    fill_in "parent_password_confirmation", :with => "testme"
    click_button "submit_registration"
    current_path.should == parents_path
  end

  scenario "Parent completes registration information" do
    parent = FactoryGirl.create(:parent)
    visit(edit_parent_path(parent))
    fill_in "parent_address1", :with =>"herby@herby"
    fill_in "parent_address2", :with => "1A"
    fill_in "parent_city", :with => "Anywhere"
    fill_in "parent_state", :with => "NY"
    fill_in "parent_zip", :with => "11223"
    fill_in "parent_primary_phone", :with => "555-321-7654"
    fill_in "demographics_num_adults", :with =>"1"
    fill_in "demographics_num_minors", :with => "2"
    choose  "25,000-49,999"
    choose  "High school"
    choose  "Own"
    click_button "Save"
    current_path.should == parent_path(parent)
    binding.pry
    parent.reload
    parent.registration_complete?.should be_true
    current_path.should == new_student_registration_path
  end

end
