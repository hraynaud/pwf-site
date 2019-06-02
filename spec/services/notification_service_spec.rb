describe NotificationService do

  before :all do 
    students = %W(Zoe Yasmin Xavier Wanda Umia Tynel Lassiter Wavy).map do |name|
      FactoryBot.create(:student, first_name: name, last_name: "Fencer")
    end

    same_parent_as_first = FactoryBot.create(:student, first_name: "Same", last_name: "Parent", parent: students[0].parent)


    @regs = students[0..3].map do |s|
      FactoryBot.create(:student_registration, :confirmed, student: s)
    end

    students[4..5].map do |s|
      FactoryBot.create(:student_registration, :pending, student: s)
    end

    FactoryBot.create(:student_registration, :confirmed_fee_waived, student: students[6])
    FactoryBot.create(:student_registration, :wait_list, student: students[7])
    FactoryBot.create(:student_registration, :pending, student: same_parent_as_first)

    @regs[0..1].each do |reg|
      FactoryBot.create(:aep_registration, :paid, student_registration: reg)
    end
  end

  describe ".recipient_list_for" do

    it "verifies parent and student count" do
      expect(StudentRegistration.current.size).to eq 9
      expect(Parent.with_current_registrations.distinct.size).to eq 8
    end

    it "finds comfirmed list including fee waived students" do
      expect(NotificationService.recipient_list_for(NotificationService::CONFIRMED).size).to eq 5
    end

    it "finds pending students including students" do
      expect(NotificationService.recipient_list_for(NotificationService::PENDING).size).to eq 3
    end

    it "finds pending" do
      expect(NotificationService.recipient_list_for(NotificationService::WAIT_LIST).size).to eq 1
    end
    it "AEP only" do
      expect(NotificationService.recipient_list_for(NotificationService::AEP_ONLY).size).to eq 2
    end
  end

end

