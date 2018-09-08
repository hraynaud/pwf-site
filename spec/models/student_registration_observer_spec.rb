describe StudentRegistrationObserver  do

  describe "after_create" do
    let(:obs){StudentRegistrationObserver.instance }
    let(:reg){FactoryBot.create(:student_registration)}
    let(:season){Season.current}

    it "updates season status if enrollemt limit reached" do
      allow(StudentRegistration).to receive(:confirmed_students_count).and_return(100)
      expect{obs.after_create(reg); season.reload}.to change{season.status}.to(:wait_list)
    end

    it "doen't update season status if enrollemt limit hasn't been reach" do
      allow(StudentRegistration).to receive(:confirmed_students_count).and_return(98)
      expect{obs.after_create(reg); season.reload}.not_to change{season.status}
    end
  end
end
