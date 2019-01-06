feature "Aep Payment", :js=> true, :focus =>:aep_fee  do

  context "Two students in fencing " do
    let!(:parent) {FactoryBot.create(:parent, :valid, :with_current_confirmed_student_registrations)}
    let!(:student1) {parent.students.first}
    let!(:student2) {parent.students.last}
    let!(:student_reg1) {student1.current_registration}
    let!(:student_reg2) {student2.current_registration}

    scenario "No AEP payment link if now AEP registrations" do
      do_login(parent)
      assert_no_aep_payment_link
    end

    context "1 student enrolls in aep" do

      scenario "1 student enrolls in aep, shows 1 pending payment" do
        FactoryBot.create(:aep_registration, student_registration: student_reg1)
        do_login(parent)
        click_payment_link_for 1
        assert_correct_total_amount_for 1
      end

      scenario "both student enroll in aep, shows 2 pending payments" do
        FactoryBot.create(:aep_registration, student_registration: student_reg1)
        FactoryBot.create(:aep_registration, student_registration:  student_reg2)
        do_login(parent)
        click_payment_link_for 2
        assert_correct_total_amount_for 2
      end

      scenario "both students enrolled in aep but one unpaid" do
        FactoryBot.create(:aep_registration, student_registration: student_reg1)
        FactoryBot.create(:aep_registration,:paid, :student_registration => student_reg2)
        do_login(parent)
        click_payment_link_for 1
        assert_correct_total_amount_for 1
      end


      scenario "User checks out with card",:js => true  do
        FactoryBot.create(:aep_registration, student_registration: student_reg1)
        FactoryBot.create(:aep_registration, student_registration:  student_reg2)
        do_login(parent)
        click_payment_link_for 2
        do_pay_with_card
        expect(page).to have_content("Payment Transaction Completed")
        click_link "Dashboard"
        assert_no_aep_payment_link
      end

    end
  end

  def aep_fee
    @fee ||= Season.current.aep_fee
  end

  def assert_no_aep_payment_link 
    expect(page).to_not have_content (/You have \d Pending payment for the AEP Program/)
  end

  def click_payment_link_for count
    click_link "You have #{count} Pending payment for the AEP Program"
  end

  def assert_correct_total_amount_for num_regs
    expect(page).to have_content "Total:\n$#{num_regs * aep_fee}"
  end

end
