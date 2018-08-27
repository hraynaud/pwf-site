describe StudentRegistration  do
  context "valid" do

    it "is valid with all all required fields" do
      expect{FactoryBot.create(:student_registration)}.to change{StudentRegistration.count}.by(1)
    end

    it "is wait_listed if season is in waitlist status" do
      season = Season.current
      season.wait_list!
      season.save
      reg = FactoryBot.build(:student_registration)

      expect{reg.save}.to change{StudentRegistration.current_wait_listed.count}.by(1)
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

end
