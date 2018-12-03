describe "registrations ", type: :feature do
  context "visit sign in" do
    it "renders registration form" do
      visit new_user_registration_path
      expect(page).to have_current_path(new_user_registration_path)
    end
  end 

  it "re renders registration form when invalid" do
      visit new_user_registration_path
      fill_in("First Name", with: "I am")
      fill_in("Last Name", with: "Programmer")
      click_button "Continue"
      expect(page).to have_current_path(users_path) # devise renders /users on registration failure
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


