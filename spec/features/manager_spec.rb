require 'spec_helper'


feature "AEP Manager" do
  let(:manager){FactoryGirl.create(:manager_user)}
  before do
   FactoryGirl.create_list(:student, 5)
   do_login(manager)
  end


 scenario "Log in to dashboard" do
   current_path.should == dashboard_path(manager)
 end


end
