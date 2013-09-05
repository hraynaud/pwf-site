feature "Aep Payment", :js=> true, :focus =>:aep_fee  do

  context " Parent pays for aep registration" do
    let!(:parent) {FactoryGirl.create(:parent)}
    let!(:student1) {FactoryGirl.create(:student, :parent=>parent)}
    let!(:student2) {FactoryGirl.create(:student, :parent=>parent)}
    let!(:student_reg1) {FactoryGirl.create(:paid_registration, :student => student1)}
    let!(:student_reg2) {FactoryGirl.create(:paid_registration, :student => student2)}
    let!(:aep_reg) {FactoryGirl.create(:complete_aep_registration, :student_registration => student_reg1)}
    let!(:user) {parent.user} 


    context "Two students in aep" do
      let!(:aep_reg2) {FactoryGirl.create(:complete_aep_registration, :student_registration => student_reg2)}
      before do
        login_and_attempt_aep_payment
      end
      scenario "Parent only pays for students registered in aep" do
        page.should have_content "Total Amount Due: $#{2 * Season.current.aep_fee}"
      end
    end

    context "Parent cannot make payment if no unpaid registrations exists" do
      before do
        aep_reg.paid!
        aep_reg.save
        do_login(user)
      end
      scenario "Parent only pays for students registered in aep" do
        click_link  "Academic Program"
        page.should have_no_selector "pay"
      end
    end
    context "Two students in aep 1 paid" do
      let!(:aep_reg2) {FactoryGirl.create(:paid_aep_registration, :student_registration => student_reg2)}
      before do
        login_and_attempt_aep_payment
      end
      scenario "Parent can only pays for students registered in aep" do
        page.should have_content "Total Amount Due: $#{1 * Season.current.aep_fee}"
      end
    end
    context "Two students in program 1 student in aep" do
      before do
        login_and_attempt_aep_payment
      end

      scenario "Parent can only pay for students registered in aep" do
        page.should have_content "Total Amount Due: $#{1 * Season.current.aep_fee}"
      end
    end

    context "Pay fee" do
      before do
        login_and_attempt_aep_payment
      end
      scenario "User checks out with card",:js => true  do
        click_button "Make Payment"
        do_pay_with_card
        page.should have_content("Payment Transaction Completed")
        parent.current_unpaid_aep_registrations.count.should == 0
      end

      scenario "User checks out with paypal", :js => true do
        FakeWeb.allow_net_connect = true
        click_button "Make Payment"
        do_pay_with_paypal
        fill_in "login_email", :with => ENV['PAYPAL_BUYER']
        fill_in "login_password", :with =>ENV['PAYPAL_BUYER_PASSWORD']
        click_button "Log In"
        page.first("input[type='submit']").click
        page.should have_content("Payment Transaction Completed")
        parent.current_unpaid_aep_registrations.count.should == 0
      end
    end
  end

  def login_and_attempt_aep_payment
    do_login(user)
    attempt_aep_payment
  end

  def attempt_aep_payment
    click_link  "Academic Program"
    click_link  "Pay AEP Fees"
  end

end
