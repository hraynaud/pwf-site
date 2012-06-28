describe Parent do
  it "should be valid" do
    parent = FactoryGirl.create(:parent)
    parent.valid?(:create).should be_true
    parent.registration_complete?.should be_false
  end

  it "should be valid" do
    parent = FactoryGirl.create(:complete_parent)
    parent.valid?(:create).should be_true
    parent.registration_complete?.should be_true
  end
end
