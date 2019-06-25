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

    before :all do
      setup_students
      setup_previous_season_registration
    end

    before :each do
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

    def setup_students
      @students = %W(Zoe Yasmin Xavier Wanda Umia Tynel Lassiter Wavy heighti).map do |name|
        FactoryBot.create(:student, first_name: name, last_name: "Fencer")
      end
      @unsaved_registrations = []
      @blocked_regs = FactoryBot.create_list(:student, 2 )
      create_sibling @students[0]
    end

    def setup_previous_season_registration

      FactoryBot.create_list(:student_registration, 3, :confirmed, :previous)

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
      build_current_blocked

      @unsaved_registrations.map(&:save)
      setup_aep_registrations
    end

    def create_sibling sibling
      @students <<  FactoryBot.create(:student, first_name: "Same", last_name: "Parent", parent: sibling.parent )
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

    end

    def build_current_blocked
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

    def setup_aep_registrations
      FactoryBot.create(:aep_registration, :paid, student_registration: @confirmed[0])
    end

    def build_current_registration status, student
      FactoryBot.build(:student_registration, status, student: student)
    end

  end
end
