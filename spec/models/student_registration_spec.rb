describe StudentRegistration  do
  context "valid" do

    it "is valid with all required fields" do
      reg = FactoryBot.build(:student_registration)
      expect{reg.save}.to change{StudentRegistration.count}.by(1)
      expect(reg.status).to be :pending
    end

    it "is wait_listed if season is in waitlist status" do
      season = Season.current
      season.wait_list!
      season.save
      reg = FactoryBot.build(:student_registration)
      expect{reg.save}.to change{StudentRegistration.current_wait_listed.count}.by(1)
    end

    it "is blockd if previous report card required" do
      @student = FactoryBot.create(:student)
      @prev_reg = FactoryBot.create(:student_registration, :confirmed, :previous, :student => @student)
      @reg = FactoryBot.create(:student_registration, :confirmed, :student => @student)
      expect(@reg.status).to eq :blocked_on_report_card
    end
    context "report card validation" do
      before do
        MarkingPeriod.create(name: "Fall/Winter")
        MarkingPeriod.create(name: "Spring/Summer")
      end

      it "is not blockd if previous report cards provided " do

        @student = FactoryBot.create(:student)
        @prev_reg = FactoryBot.create(:student_registration, :confirmed, :previous, :student => @student)
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: Season.previous.term,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.first_session.id)
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: Season.previous.term,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.second_session.id)
        @reg = FactoryBot.create(:student_registration, :student => @student)

        expect(@reg.status).to eq :pending
      end
    end
  end

  describe "in_aep" do
    it "counts correctly ignoring non confirmed registrations" do
      FactoryBot.create(:student_registration, :confirmed)
      expect(StudentRegistration.in_aep.count).to eq(0)
      expect(StudentRegistration.not_in_aep.count).to eq 1
    end

    it "counts correctly ignoring non confirmed registrations" do
      FactoryBot.create(:student_registration, :confirmed)
      FactoryBot.create(:student_registration)
      FactoryBot.create(:aep_registration)
      expect(StudentRegistration.in_aep.count).to eq(1)
      expect(StudentRegistration.not_in_aep.count).to eq 1
    end
  end

  describe "not_in_aep" do
    it "counts correctly ignoring non confirmed registrations" do
      FactoryBot.create(:student_registration, :confirmed)
      FactoryBot.create(:student_registration)
      FactoryBot.create(:aep_registration)
      expect(StudentRegistration.in_aep.count).to eq(1)
      expect(StudentRegistration.not_in_aep.count).to eq 1
    end
  end

  context "invalid" do
    let(:reg){FactoryBot.build(:student_registration)}

    it "is invalid without season" do
      reg.season = nil
      expect{reg.save}.to change{StudentRegistration.count}.by(0)
    end

    it "is invalid without student" do
      reg.student = nil
      expect{reg.save}.to change{StudentRegistration.count}.by(0)
    end

    it "is invalid without size" do
      reg.size = nil
      expect{reg.save}.to change{StudentRegistration.count}.by(0)
    end

    it "is invalid without school" do
      reg.school = nil
      expect{reg.save}.to change{StudentRegistration.count}.by(0)
    end

    it "is invalid without grade" do
      reg.grade = nil
      expect{reg.save}.to change{StudentRegistration.count}.by(0)
    end
  end

  describe "#destroy" do

    it "destroys associated objects" do
      reg = FactoryBot.create(:student_registration, :confirmed, :with_aep)
      FactoryBot.create(:report_card,  :with_transcript, student_registration: reg)
      FactoryBot.create(:report_card,  :with_transcript, marking_period: 2, student_registration: reg)
      FactoryBot.create(:attendance, session_date: 1.week.ago, student_registration: reg)
      FactoryBot.create(:attendance, session_date: Date.yesterday,  student_registration: reg)
      expect{reg.destroy}.to change{AepRegistration.count}.by(-1)
        .and change{ReportCard.count}.by(-2)
        .and change{Attendance.count}.by(-2)
    end
  end
end
