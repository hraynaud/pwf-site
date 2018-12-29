describe "registrations ", type: :feature do

  it "re renders registration form when invalid" do
    visit new_user_registration_path
    fill_in("First Name", with: "I am")
    fill_in("Last Name", with: "Programmer")
    fill_in("Email", with: "programmer@iam.com")
    fill_in("Password", with: "password")
    fill_in("Password Confirmation", with: "yarda")
    click_button "Continue"
    expect(page).to have_current_path(users_path) #NOTE devise renders /users on registration failure which is the target of the previous post
  end

  it "renders edit when successful" do
    visit new_user_registration_path
    fill_in("First Name", with: "I am")
    fill_in("Last Name", with: "Programmer")
    fill_in("Email", with: "programmer@iam.com")
    fill_in("Password", with: "password")
    fill_in("Password Confirmation", with: "password")
    click_button "Continue"
    expect(page).to have_current_path(edit_parent_path(User.last))
  end

  it "renders dashboard when all required data is provided" do
    visit new_user_registration_path
    fill_in("First Name", with: "I am")
    fill_in("Last Name", with: "Programmer")
    fill_in("Email", with: "programmer@iam.com")
    fill_in("Password", with: "password")
    fill_in("Password Confirmation", with: "password")
    click_button "Continue"
    expect(page).to have_current_path(edit_parent_path(User.last))
    click_link "Contact"
    fill_in "Primary phone", :with => "555-321-7654"
    fill_in "Address1", :with =>"123 Main Street"
    fill_in "Address2", :with => "1A"
    fill_in "City", :with => "Anywhere"
    select  "New York", :from =>  "State"
    fill_in "Zip", :with => "11223"
    click_link "Household"
    fill_in "Num adults", :with =>"1"
    fill_in "Num minors", :with => "2"
    choose  "$25,000 - $49,999"
    choose  "High school"
    choose  "Own"
    click_button "Save"
    expect(page).to have_current_path(dashboard_path)
  end

  it "renders user edit if data is invalid" do
    visit new_user_registration_path
    fill_in("First Name", with: "I am")
    fill_in("Last Name", with: "Programmer")
    fill_in("Email", with: "programmer@iam.com")
    fill_in("Password", with: "password")
    fill_in("Password Confirmation", with: "password")
    click_button "Continue"
    expect(page).to have_current_path(edit_parent_path(User.last))
    click_link "Contact"
    fill_in "Primary phone", :with => "555-321-7654"
    fill_in "Address1", :with =>"123 Main Street"
    fill_in "Address2", :with => "1A"
    fill_in "City", :with => "Anywhere"
    select  "New York", :from =>  "State"
    fill_in "Zip", :with => "11223"
    click_button "Save"
    expect(page).to have_current_path(parent_path(User.last))
  end

  scenario "Existing parent with missing household_details" do
    parent = FactoryBot.create(:parent, :with_contact_detail)
    do_login(parent)
    page.should have_content "Your profile information is incomplete or invalid"
    click_link "Household"
    fill_in "Num adults", :with =>"1"
    fill_in "Num minors", :with => "2"
    choose  "$25,000 - $49,999"
    choose  "High school"
    choose  "Own"
    click_button "Save"
    expect(page).to have_current_path(dashboard_path)
  end

private

def build_params valid_or_invalid
  {user: send(valid_or_invalid)}
end

def valid
  FactoryBot.attributes_for(:user)
end

def invalid
  FactoryBot.attributes_for(:user, :invalid)
end


end

