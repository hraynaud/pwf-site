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

  describe ".to_be_notified_if_waitlist_opens" do
    it "list wait_listed parents who want to be notified" do

    end
  end

  context "scopes" do 

    before :each do
      setup_students
      setup_previous_season_registration
      setup_current_season_registration
    end

    describe ".with_various_scopes" do 

      it "finds correct scopes" do
        expect(Student.all.size).to eq 19
        expect(Parent.all.size).to eq 18
        expect(Student.find_by(first_name: "Same").student_registrations.size).to eq 0
        expect(StudentRegistration.all.size).to eq 23
        expect(StudentRegistration.current.size).to eq 12
        expect(Parent.with_current_registrations.size).to eq 12
        expect(Parent.with_current_confirmed_registrations.size).to eq 6
        expect(Parent.with_current_pending_registrations.size).to eq 3
        expect(Parent.with_current_pending_registrations.exclude_selected(@exclude_list).count).to eq 2
        expect(Parent.with_current_wait_listed_registrations.size).to eq 1

        expect(Parent.with_aep_registrations.size).to eq 1

        expect(Parent.with_unrenewed_registrations.count).to eq 3
        expect(Parent.with_previous_wait_listed_registrations.count).to eq 4
        expect(Parent.with_backlog_wait_listed_registrations.count).to eq 3
        expect(Parent.with_wait_list_priority.count).to eq 2
      end

      it "finds by report card status" do
        expect(Parent.with_current_blocked_on_report_card_registrations.size).to eq 2
        expect(Parent.with_current_unsubmitted_transcript_for(MarkingPeriod.first_session).count).to eq 8
        expect(Parent.with_current_unsubmitted_transcript_for(MarkingPeriod.second_session).count).to eq 7
      end
    end
  end
end
