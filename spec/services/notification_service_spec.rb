describe NotificationService do

  before :all do
    setup_students
    setup_previous_season_registration
  end

  before :each do
    setup_current_season_registration
  end


  describe ".recipient_list_for" do

    it "verifies current parent and student count" do
      expect(Student.all.size).to eq 12
      expect(StudentRegistration.current.size).to eq 11
      expect(StudentRegistration.all.size).to eq 15
      expect(Parent.all.size).to eq 11
      expect(Parent.with_current_registrations.distinct.size).to eq 10
    end

    it "finds comfirmed list including fee waived students" do
      expect(NotificationService.recipient_list_for(NotificationService::CONFIRMED).size).to eq 5
    end

    it "finds it students including students" do
      expect(NotificationService.recipient_list_for(NotificationService::PENDING).size).to eq 3
    end

    it "finds waitlist" do
      expect(NotificationService.recipient_list_for(NotificationService::WAIT_LIST).size).to eq 1
    end

    it "finds AEP only" do
      expect(NotificationService.recipient_list_for(NotificationService::AEP_ONLY).size).to eq 2
    end

    it "finds blocked due to missing report card" do
      expect(NotificationService.recipient_list_for(NotificationService::BLOCKED_ON_REPORT_CARD).size).to eq 2
    end
  end

end

def setup_students
  @students = %W(Zoe Yasmin Xavier Wanda Umia Tynel Lassiter Wavy ).map do |name|
    FactoryBot.create(:student, first_name: name, last_name: "Fencer")
  end

  @unsaved_registrations = []

  create_blocked_student
  create_sibling @students[0]
  create_unregistered_student
end

def create_sibling sibling
  @students <<  FactoryBot.create(:student, first_name: "Same", last_name: "Parent", parent: sibling.parent )
end

def setup_previous_season_registration
  @students[4..5].each do |s|
    FactoryBot.create(:student_registration,  :confirmed, :previous, student: s)
  end

  @blocked_regs.each do |s|
    FactoryBot.create(:student_registration,  :confirmed, :previous, student:s)
  end
end

def setup_current_season_registration
  build_current_confirmed
  build_current_pending
  build_wait_list

  @unsaved_registrations.map(&:save)
  setup_aep_registrations
end

def build_current_confirmed

  @confirmed = @students[0..3].map do |s|
    reg = build_current_registration(:confirmed, s)
    @unsaved_registrations << reg
    reg
  end

  waived = build_current_registration(:confirmed_fee_waived, @students[6])
  @unsaved_registrations << waived
  @confirmed << waived

  @blocked_regs.each do |reg|
    blocked = build_current_registration(:confirmed, reg)
    @unsaved_registrations << blocked
  end

end

def build_current_pending
  @students[4..5].each do |s|
    reg = build_current_registration(:pending, s)
    allow(reg).to receive(:requires_last_years_report_card?) {false}
    @unsaved_registrations << reg
  end

  @unsaved_registrations << build_current_registration(:pending, @students[8])
end

def build_wait_list
  @unsaved_registrations << build_current_registration(:wait_list, @students[7])
end

def create_blocked_student
  @blocked_regs = FactoryBot.create_list(:student, 2 )
end

def setup_aep_registrations
  @confirmed[0..1].each do |reg|
    FactoryBot.create(:aep_registration, :paid, student_registration: reg)
  end
end

def build_current_registration status, student
  FactoryBot.build(:student_registration, status, student: student)
end


def create_unregistered_student
  FactoryBot.create(:student, first_name: "Unregistered" , last_name: "Fencer")
end

