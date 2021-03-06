describe Season do
  it "should be valid" do
    season = FactoryBot.create(:season)
    expect(season).to be_valid
  end

  describe "#open_enrollment_period_is_active?" do
    it "it is true if enrollment under limit and  season current and open_enrollment_date < today" do
      season = FactoryBot.build(:season, open_enrollment_date: 1.months.ago, enrollment_limit: 150, current: true )
      #allow(season).to receive(:confirmed_students_count).and_return(149)
      expect(season.open_enrollment_period_is_active?).to be true
    end

    it "it is false if enrollment in future" do
      season = FactoryBot.create(:season, open_enrollment_date: 2.months.from_now, enrollment_limit: 150, current: true)
      expect(season.open_enrollment_period_is_active?).to be false
    end

    it "it is false if season isn't current " do
      season = FactoryBot.create(:season, open_enrollment_date: 1.months.ago, enrollment_limit: 150, current: false )
      #allow(season).to receive(:confirmed_students_count).and_return(149)
      expect(season.open_enrollment_period_is_active?).to be false
    end

    #it "it is false if enrollment over limit" do
      #season = FactoryBot.create(:season, open_enrollment_date: 1.months.ago, enrollment_limit: 150 )
      ##allow(season).to receive(:confirmed_students_count).and_return(151)
      #expect(season.open_enrollment_period_is_active?).to be false
    #end
  end

  describe "#wait_list_enrollment_period_is_active?" do
    it "it is true if enrollment under limit and  season current and waitlist_regisration_date < today" do
      season = FactoryBot.build(:season, waitlist_registration_date: 1.months.ago, enrollment_limit: 150, current: true )
      #allow(season).to receive(:confirmed_students_count).and_return(149)
      expect(season.wait_list_enrollment_period_is_active?).to be true
    end

    it "it is false if enrollment in future" do
      season = FactoryBot.create(:season, waitlist_registration_date: 2.months.from_now, enrollment_limit: 150, current: true)
      expect(season.wait_list_enrollment_period_is_active?).to be false
    end

    it "it is false if season isn't current " do
      season = FactoryBot.create(:season, waitlist_registration_date: 1.months.ago, enrollment_limit: 150, current: false )
      #allow(season).to receive(:confirmed_students_count).and_return(149)
      expect(season.wait_list_enrollment_period_is_active?).to be false
    end

    #it "it is false if enrollment over limit" do
      #season = FactoryBot.create(:season, waitlist_registration_date: 1.months.ago, enrollment_limit: 150 )
      ##allow(season).to receive(:confirmed_students_count).and_return(151)
      #expect(season.wait_list_enrollment_period_is_active?).to be false
    #end
  end




  describe "#should_waitlist_new_registrations?" do
    it "it is true if enrollment over limit" do
      season = FactoryBot.create(:season, open_enrollment_date: 1.months.ago, current: true, enrollment_limit: 150 )
      allow(season).to receive(:confirmed_students_count).and_return(151)
      expect(season.should_waitlist_new_registrations?).to be true 
    end

    it "it is false if enrollment in future" do
      season = FactoryBot.create(:season, open_enrollment_date: 2.months.from_now, enrollment_limit: 150, current: true)
      expect(season.should_waitlist_new_registrations?).to be false
    end
  end





end
