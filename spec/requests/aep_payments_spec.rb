feature "Aep Payment", :js=> true, :focus =>:aep_fee  do

  context " Parent pays for aep registration" do
    let!(:parent) {FactoryBot.create(:parent, :valid)}
    let!(:student1) {FactoryBot.create(:student, :parent=>parent)}
    let!(:student2) {FactoryBot.create(:student, :parent=>parent)}
    let!(:student_reg1) {FactoryBot.create(:student_registration, :confirmed, student: student1)}
    let!(:student_reg2) {FactoryBot.create(:student_registration, :confirmed, student: student2)}
    let!(:aep_reg) {FactoryBot.create(:aep_registration, :complete, student_registration: student_reg1)}
    let!(:user) {parent} 


    context "Two students enrolled in AEP with unpaid AEP registrations" do
      let!(:aep_reg2) {FactoryBot.create(:aep_registration, :paid, :student_registration => student_reg2)}

      before do
        do_login(user)
        expect(page).to have_content /You have 1 Pending payment for the AEP Program/
        attempt_aep_payment_for 1
      end

      scenario "Parent only pays for students registered in aep" do
        expect(page).to have_content "Total:\n$#{Season.current.aep_fee}"
      end

    end

    context "Parent cannot make payment if no unpaid registrations exists" do
      before do
        aep_reg.paid!
        aep_reg.save
        do_login(user)
      end

      scenario "Parent only pays for students registered in aep" do
        expect(page).to_not have_content /You have \d Pending payment for the AEP Program/
      end

    end
    context "Two students in aep 1 paid" do
      let!(:aep_reg2) {FactoryBot.create(:aep_registration,:paid, :student_registration => student_reg2)}
      before do
        do_login(user)
        expect(page).to have_content /You have 1 Pending payment for the AEP Program/
        attempt_aep_payment_for 1
      end

      scenario "Parent can only pays for students registered in aep" do
        expect(page).to have_content "Total:\n$#{Season.current.aep_fee}"
      end
    end

    context "Two students in program 1 student in aep" do
      before do
        do_login(user)
        attempt_aep_payment_for 1
      end

      scenario "Parent can only pay for students registered in aep" do
        expect(page).to have_content "Total:\n$#{Season.current.aep_fee}"
      end
    end

    context "Pay fee" do
      before do
        do_login(user)
        attempt_aep_payment_for 1
      end

      scenario "User checks out with card",:js => true  do
        do_pay_with_card
        expect(page).to have_content("Payment Transaction Completed")
        parent.current_unpaid_aep_registrations.count.should == 0
      end

    end
  end


  def attempt_aep_payment_for count
    click_link  "You have #{count} Pending payment for the AEP Program"
  end

end
