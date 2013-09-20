require 'spec_helper'

feature "Sign in and Sign Out of Work" do
  let!(:user){FactoryGirl.create(:parent_with_current_demographic_profile).user}
  scenario "login to site" do
    do_login(user)
    current_path.should == dashboard_path
  end


  scenario "Try to access site when current season is nil", :focus => :failing do
    Season.where(:current => true).delete_all
    do_login(user)
    current_path.should == registration_closed_path 
  end
end
