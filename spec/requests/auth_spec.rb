require 'spec_helper'

feature "Sign in and Sign Out of Work" do
  scenario "login to site" do
    parent = FactoryGirl.create(:complete_parent)
    do_login(parent)
    current_path.should == parent_path(parent)
  end
end
