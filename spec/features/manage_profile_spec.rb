require 'spec_helper'

RSpec.describe "Parent manages profile and students registrations" do
  let(:user){FactoryGirl.create(:parent_with_current_demographic_profile).user}
  #TODO make this work for all user types
  it "Parent updates own information" do
    do_login(user)
    click_link "my_profile"
    current_path.should == parent_path(parent)

    click_link "Edit"
    do_fillin_parent_info "address1" => "456 Main Street"
    click_button "Save"
    parent.reload
    parent.address1.should == "456 Main Street"
  end

end
