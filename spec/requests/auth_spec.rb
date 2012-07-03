require 'spec_helper'

feature "Sign in and Sign Out of Work" do
  scenario "login to site" do
    parent = FactoryGirl.create(:complete_parent)
    do_login(parent)
    current_path.should == parent_path(parent)
  end


  scenario "Try to access site when current season is nil" do
   Season.current.destroy if Season.current
    parent = FactoryGirl.create(:complete_parent)
    visit login_path
    current_path.should == registration_closed_path
  end
end
