include StudentRegistrationsForSeasonHelper
describe NotificationService do

  before :each do
    setup_students
    setup_previous_season_registration
    setup_current_season_registration
  end

  describe ".recipient_list_for" do

    it "verifies current parent and student count" do
      expect(Student.all.size).to eq 15
      expect(Parent.all.size).to eq 14
      expect(StudentRegistration.current.size).to eq 11
      expect(StudentRegistration.all.size).to eq 18
      expect(Parent.with_current_registrations.distinct.size).to eq 11
    end

    it "finds comfirmed list including fee waived students" do
      expect(NotificationService.recipient_list_for(NotificationService::CONFIRMED).size).to eq 5
    end

    it "finds pending students" do
      expect(NotificationService.recipient_list_for(NotificationService::PENDING).size).to eq 3
    end

    it "finds waitlist" do
      expect(NotificationService.recipient_list_for(NotificationService::WAIT_LIST).size).to eq 1
    end

    it "finds AEP only" do
      expect(NotificationService.recipient_list_for(NotificationService::AEP_ONLY).size).to eq 1
    end

    it "finds blocked due to missing report card" do
      expect(NotificationService.recipient_list_for(NotificationService::BLOCKED_ON_REPORT_CARD).size).to eq 2
    end

    it "finds blocked due to missing report card" do
      expect(NotificationService.recipient_list_for(NotificationService::UNRENEWED_PARENTS).size).to eq 3
    end
  end

end

