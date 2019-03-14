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


  describe ".with_registrations" do

  end

  describe ".by_student_registration_status" do
    pending "counts correctly "
  end

  describe ".with_previous_registrations" do
    pending "counts correctly"
  end

  describe ".with_current_registrations" do 
    pending "counts correctly"
  end

  describe ".with_confirmed_registrations" do 

    pending "counts correctly"
  end
 
  describe ".with_current_confirmed_registrations" do 
    pending "counts correctly"
  end

  describe ".with_pending_registrations" do 
    pending "counts correctly"
  end

  describe ".with_current_pending_registrations" do 
    pending "counts correctly"
  end

  describe ".with_wait_listed_registrations" do 
    pending "counts correctly"
  end

  describe ".with_current_wait_listed_registrations" do 
    pending "counts correctly"
  end

  describe ".with_aep_registrations" do 

    pending "counts correctly"
  end

  describe ".with_unpaid_aep_registrations" do 

    pending "counts correctly"
  end

  describe ".with_no_aep_registrations" do 

    pending "counts correctly"
  end

end
