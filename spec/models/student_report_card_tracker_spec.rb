describe StudentReportCardTracker do

  before do
    @student = FactoryBot.create(:student)
    @prev_reg = FactoryBot.create(:student_registration, :confirmed, :previous, :student => @student)
    @reg = FactoryBot.create(:student_registration, :confirmed, :student => @student)
    @fw = MarkingPeriod.create(name: "Fall/Winter")
    @ss = MarkingPeriod.create(name: "Spring/Summer")
    @q1 = MarkingPeriod.create(name: "Q1")
    @q2 = MarkingPeriod.create(name: "Q2")
  end

  context "Report cards for previous academic year" do
    before do
      @tracker = StudentReportCardTracker.new(@student, Season.previous.academic_year)
    end

    it "has correct student and year" do
      expect(@tracker.student).to eq @student
      expect(@tracker.school_year).to eq Season.previous.term
    end

    describe "first_session_transcript_provided?" do
      it "it true if report card submitted for for first session the tracked academic year " do
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year, 
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.first_session.id)
        expect(@tracker.first_session_transcript_provided?).to be true
      end
    end

    describe "second_session_transcript_provided?" do
      it "it is true if report card submitted for second session the tracked academic year " do

        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year, 
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.second_session.id)
        expect(@tracker.second_session_transcript_provided?).to be true
      end
    end

    describe "has_uploaded_first_and_second_report_card_for_season?" do
      it "is false if the first sessionreport_card is missing" do
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: @q1.id)
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.second_session.id)
        expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be false
      end

      it "is false if the second sessionreport_card is missing" do
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.first_session.id)
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: @q2.id)
        expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be false
      end

      it "is true if both report_cards are uploaded" do
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.first_session.id)
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: previous_academic_year,
                          student_registration: @prev_reg, 
                          marking_period: MarkingPeriod.second_session.id)

        expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be true
      end
    end

  end

  context "Report cards for current academic year" do
    before do
      @tracker = StudentReportCardTracker.new(@student, Season.current.academic_year)
    end

    it "has correct student and year" do
      expect(@tracker.student).to eq @student
      expect(@tracker.school_year).to eq Season.current.term
    end

    describe "has_uploaded_first_and_second_report_card_for_season?" do

      it "is false if the first session report_card is not in same year" do
        FactoryBot.create(:report_card, :with_transcript, 
                          academic_year: current_academic_year,
                          student_registration: @reg,
                          marking_period: MarkingPeriod.first_session.id)
        FactoryBot.create(:report_card, :with_transcript,
                          academic_year: previous_academic_year,
                          student_registration: @reg,
                          marking_period: MarkingPeriod.second_session.id)
        expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be false
      end
    end
  end
  private

  def previous_academic_year
    @prev_year ||=Season.previous.academic_year
  end

  def current_academic_year
    @curr_year ||= Season.current.academic_year
  end
end
