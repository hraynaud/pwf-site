require 'spec_helper'

feature "Parent manages profile and students registrations" do
  let(:parent){FactoryBot.create(:parent, :valid)}

  scenario "Parent updates own information" do
    do_login(parent)
    click_link "Profile"
    expect(current_path).to eq edit_parent_path(parent)
    click_link "Contact"
    fill_in "Address1", :with =>"456 Montgomery"
    click_button "Save"
    expect(page).to have_content "Profile information saved"
  end

end
