require 'spec_helper'

RSpec.describe "Sign in and Sign Out of Work" do
  let!(:user){FactoryGirl.create(:parent_with_current_demographic_profile).user}
  it "login to site" do
    do_login(user)
    current_path.should == dashboard_path
  end


  it "Try to access site when current season is nil", :focus => :failing do
    Season.where(:current => true).delete_all
    do_login(user)
    current_path.should == registration_closed_path 
  end
end
