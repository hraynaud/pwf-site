include StudentRegistrationsForSeasonHelper
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

  context "scopes" do 

    before :each do
      setup_students
      setup_previous_season_registration
      setup_current_season_registration
    end

    describe ".with_pending_registrations" do 
      it "finds pending" do
        expect(Student.all.size).to eq 15
        expect(StudentRegistration.all.size).to eq 18
        expect(StudentRegistration.current.size).to eq 11
        expect(Parent.with_current_registrations.size).to eq 11
        expect(Parent.with_current_confirmed_registrations.size).to eq 5
        expect(Parent.with_current_pending_registrations.size).to eq 3
        expect(Parent.with_current_wait_listed_registrations.size).to eq 1
        expect(Parent.with_current_blocked_on_report_card_registrations.size).to eq 2
        expect(Parent.with_aep_registrations.size).to eq 1
      end
    end
  end
end
