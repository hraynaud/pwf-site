describe Parent do

  it "valid with current demographic profile" do
    parent = FactoryBot.build(:parent)
    expect(parent.valid?).to be true
  end

  describe "has_current_unpaid_fencing_registrations" do
    it "should be true if there are pending registrations" do
      parent = FactoryBot.create(:parent, :valid, :with_current_student_registrations)
      expect(parent.has_current_unpaid_fencing_registrations?).to be true
    end
  end

  describe "current_unpaid_registrations" do
    it "should show count of pending registrations" do
      parent = FactoryBot.create(:parent, :valid, :with_current_student_registrations)
      expect(parent.unpaid_registrations.count).to eq 2
    end
  end

end
