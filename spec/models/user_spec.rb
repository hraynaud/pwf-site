describe User do
  it "is not valid " do
    user = FactoryBot.build(:user)
    expect(user.valid?).to eq true
  end

end
