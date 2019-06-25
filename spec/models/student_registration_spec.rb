describe StudentRegistration  do

  describe ".with_unsubmitted_transcript_for" do
    before do 
      @fall = FactoryBot.create(:marking_period)
      @spring = FactoryBot.create(:marking_period, name: MarkingPeriod::SECOND_SESSION)
      @reg1 = FactoryBot.create(:student_registration, :confirmed)
      @reg2 = FactoryBot.create(:student_registration, :confirmed)
    end

    it "finds students with missing Fall/Winter report card" do
      expect(StudentRegistration.with_unsubmitted_transcript_for(:fall_winter_report_card).size).to eq(2)
    end

    #it "excludes students with submitted report card" do
      #FactoryBot.create(:report_card, :with_transcript, marking_period: @fall, student_registration:  @reg1)
      #expect(StudentRegistration.with_unsubmitted_transcript_for(:fall_winter_report_card).size).to eq(1)
    #end

    it "distinguishes fall_winter report cards from spring_summer report cards" do
      FactoryBot.create(:report_card, :with_transcript, marking_period: @fall, student_registration:  @reg1)
      FactoryBot.create(:report_card, :with_transcript, marking_period: @fall, student_registration: @reg2)
      expect(StudentRegistration.with_unsubmitted_transcript_for(:spring_summer_report_card).size).to eq(2)
    end

    it "distinguishes spring_summer report cards from fall_winter report cards" do
      FactoryBot.create(:report_card, :with_transcript, marking_period: @spring, student_registration:  @reg1)
      FactoryBot.create(:report_card, :with_transcript, marking_period: @fall, student_registration: @reg2)
      expect(StudentRegistration.with_unsubmitted_transcript_for(:spring_summer_report_card).size).to eq(1)
    end
  end

  describe ".exclude_selected" do
    before do
      @reg3 = FactoryBot.create(:student_registration, :confirmed)
      @reg4 = FactoryBot.create(:student_registration, :confirmed)
      @reg5 = FactoryBot.create(:student_registration, :confirmed)
      @reg6 = FactoryBot.create(:student_registration, :confirmed)
      @reg7 = FactoryBot.create(:student_registration, :pending)
      @reg8 = FactoryBot.create(:student_registration, :wait_list)

      @params = ActiveSupport::HashWithIndifferentAccess.new
     end
    it "excludes nothing in exclude list is nil" do
      expect(StudentRegistration.all.exclude_selected(nil).size).to eq(6)
     end

    it "excludes students from in the exclude list" do
      expect(StudentRegistration.all.exclude_selected([@reg3.id, @reg6.id]).size).to eq(4)
     end
  end

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

    it "is blocked if previous report card required" do
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


      it "is not blocked if previous report cards provided " do

        @student = FactoryBot.create(:student)
        @prev_reg = FactoryBot.create(:student_registration, :confirmed, :previous, :student => @student)
        FactoryBot.create(:report_card, :with_transcript, 
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.first_session, academic_year:  Season.previous.academic_year)
        FactoryBot.create(:report_card, :with_transcript, 
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.second_session, academic_year:  Season.previous.academic_year)

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
      c = FactoryBot.create(:student_registration, :confirmed)
      FactoryBot.create(:student_registration)
      FactoryBot.create(:aep_registration,:paid, student_registration: c)
      expect(StudentRegistration.in_aep.count).to eq(1)
      expect(StudentRegistration.not_in_aep.count).to eq 1
    end
  end

  describe "not_in_aep" do
    it "counts correctly ignoring non confirmed registrations" do
      c = FactoryBot.create(:student_registration, :confirmed)
      FactoryBot.create(:student_registration, :confirmed)
      FactoryBot.create(:aep_registration,:paid,student_registration: c)
      expect(StudentRegistration.in_aep.count).to eq(1)
      expect(StudentRegistration.not_in_aep.count).to eq 1
    end
  end

  context "invalid" do

     it "is invalid if duplicated" do
       reg = FactoryBot.create(:student_registration) 
       reg2 = FactoryBot.build(:student_registration, student: reg.student)
      expect{reg2.save}.to change{StudentRegistration.count}.by(0)
     end

    context "missing fields" do
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
  end

  describe "#destroy" do

    it "destroys associated objects" do
      reg = FactoryBot.create(:student_registration, :confirmed, :with_aep)
      FactoryBot.create(:report_card,  :with_transcript, student_registration: reg)
      FactoryBot.create(:report_card,  :with_transcript, student_registration: reg)
      FactoryBot.create(:attendance, session_date: 1.week.ago, student_registration: reg)
      FactoryBot.create(:attendance, session_date: Date.yesterday,  student_registration: reg)
      expect{reg.destroy}.to change{AepRegistration.count}.by(-1)
        .and change{ReportCard.count}.by(-2)
        .and change{Attendance.count}.by(-2)
    end
  end
end
