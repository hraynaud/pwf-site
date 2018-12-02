describe "registrations " do
  context "invalid" do
    it "renders registration form" do
      visit new_user_path
      expect(response.status).to redirect_to sign_in_path
    end
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


