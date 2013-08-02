require 'spec_helper'

feature "Parent manages profile and students registrations" do
  let(:user){FactoryGirl.create(:parent_user)}
  scenario "Parent updates own information" do
    do_login(user)
    click_link "my_profile"
    current_path.should == edit_parent_path(parent)

    do_fillin_parent_info "address1" => "456 Main Street"
    click_button "Save"
    parent.reload
    parent.address1.should == "456 Main Street"
  end

end
