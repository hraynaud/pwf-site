require 'spec_helper'

feature "Sign in and Sign Out of Work" do
  let!(:user){FactoryGirl.create(:parent_user)}
  scenario "login to site" do
    do_login(user)
    current_path.should == parent_path(parent)
  end


  scenario "Try to access site when current season is nil", :focus => :failing do
    Season.where(:current => true).delete_all
    do_login(user)
    current_path.should == registration_closed_path 
  end
end
