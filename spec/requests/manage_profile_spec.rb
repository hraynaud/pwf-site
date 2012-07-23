require 'spec_helper'

feature "Parent manages profile and students registrations" do

  scenario "Parent updates own information" do
    parent = FactoryGirl.create(:complete_parent)
    do_login(parent)
    click_link "my_profile"
    current_path.should == edit_parent_path(parent)
    do_fillin_parent_info :address1 => "456 Main Street"
    click_button "Save"
    parent.reload
    parent.address1.should == "456 Main Street"
  end

  scenario "Parent with broken registration" do
    parent = FactoryGirl.create(:parent)
    parent.demographics.destroy_all
    do_login(parent)
    # current_path.should == edit_parent_path(parent)
    # do_fillin_parent_info :address1 => "456 Main Street"
    # click_button "Save"
    # parent.reload
    # parent.address1.should == "456 Main Street"
  end
end
