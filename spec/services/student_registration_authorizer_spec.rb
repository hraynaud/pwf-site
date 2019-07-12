describe  StudentRegistrationAuthorizer do

  context "registration is blocked for everyone due to dates" do 
    before do 
      allow_any_instance_of(Season).to receive(:wait_list_enrollment_period_is_active?).and_return(false)
      allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(false)
      allow_any_instance_of(Season).to receive(:pre_enrollment_enabled?).and_return(false)
    end

    describe ".can_register?" do
      it "returns false for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_confirmed_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end

      it "returns false for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end

      it "returns false for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end
    end
  end

  context "registration is blocked for everyone due to capacity" do 
    before do 
      allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(true)
      allow_any_instance_of(Season).to receive(:has_space_for_more_students?).and_return(false)
    end

    describe ".can_register?" do
      it "returns false for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_confirmed_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end

      it "returns false for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end

      it "returns false for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end
    end
  end


  context "only returning students registration open is true" do 
    before do 
      allow_any_instance_of(Season).to receive(:wait_list_enrollment_period_is_active?).and_return(false)
      allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(false)
      allow_any_instance_of(Season).to receive(:pre_enrollment_enabled?).and_return(true)
    end

    describe ".can_register?" do
      it "returns yes for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_confirmed_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns false for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end

      it "returns false for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end
    end
  end

  context "wait_list_enrollments is true" do before do 
      allow_any_instance_of(Season).to receive(:wait_list_enrollment_period_is_active?).and_return(true)
    end
    describe ".can_register?" do
      it "returns yes for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns yes for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns false for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end
    end
  end

  context "open_enrollment_active is false" do 
    before do 
      allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(false)
      allow_any_instance_of(Season).to receive(:wait_list_enrollment_period_is_active?).and_return(true)
    end
    describe ".can_register?" do
      it "returns yes for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_confirmed_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns true for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns no for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be false
      end
    end
  end

  context "open_enrollment_active is true" do 
    before do 
      allow_any_instance_of(Season).to receive(:open_enrollment_period_is_active?).and_return(true)
    end
    describe ".can_register?" do
      it "returns yes for returning enrolled students from previous season" do
        student = FactoryBot.create(:student, :with_previous_registration )
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns no for wait_listed " do
        student = FactoryBot.create(:student, :with_previous_wait_list_registration)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end

      it "returns true for new students " do
        student = FactoryBot.create(:student)
        resp = StudentRegistrationAuthorizer.can_register?(student)
        expect(resp.answer).to be true
      end
    end

  end




end
