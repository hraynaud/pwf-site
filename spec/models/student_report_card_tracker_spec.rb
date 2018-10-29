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

  context "Report cards for previous season" do
    before do
      @tracker = StudentReportCardTracker.new(@student, Season.previous.academic_year)
    end

    it "has correct student and year" do
      expect(@tracker.student).to eq @student
      expect(@tracker.school_year).to eq Season.previous.term
    end

    it "confirms NON receipt of first session report card " do
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year, 
                        student_registration: @reg)
      expect(@tracker.first_session_transcript_provided?).to be false
    end

    it "confirms receipt of first session report card " do
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year, 
                        student_registration: @reg, 
                        marking_period: MarkingPeriod.first_session.id)
      expect(@tracker.first_session_transcript_provided?).to be true
    end

    it "confirms receipt of second session report card " do
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year, 
                        student_registration: @reg, 
                        marking_period: MarkingPeriod.second_session.id)
      expect(@tracker.second_session_transcript_provided?).to be true
    end

    it "confirms NON receipt of second session report card" do
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year,
                        student_registration: @prev_reg, 
                        marking_period: @q1.id)
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year,
                        student_registration: @prev_reg, 
                        marking_period: @q2.id)
      expect(@tracker.first_session_transcript_provided?).to be false
      expect(@tracker.second_session_transcript_provided?).to be false
      expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be false
    end

    it "confirms receipt of second session report card" do
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year,
                        student_registration: @reg, 
                        marking_period: MarkingPeriod.first_session.id)
      FactoryBot.create(:report_card, :with_transcript, 
                        academic_year: previous_academic_year,
                        student_registration: @reg, 
                        marking_period: MarkingPeriod.second_session.id)

      expect(@tracker.first_session_transcript_provided?).to be true
      expect(@tracker.second_session_transcript_provided?).to be true
      expect(@tracker.has_uploaded_first_and_second_report_card_for_season?).to be true
    end

  end
  private

  def previous_academic_year
    Season.previous.academic_year
  end

end
