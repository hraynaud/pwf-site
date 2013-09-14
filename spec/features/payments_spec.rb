require 'spec_helper'

feature "Process payments for a registration", :focus => :payment do
  scenario " Happy day parent registers and pays for registration" do
    parent = FactoryGirl.create(:parent_with_current_demographic_profile)
    user =parent.user
    do_login(user)
    do_create_new_student
    click_link "pay"
    current_path.should == new_payment_path
    page.should have_content "Total Amount Due: $#{parent.current_unpaid_pending_registrations.count * 50}"
  end

  context "pre-existing student registrations" do
    let(:parent){FactoryGirl.create(:parent_with_old_student_registrations)}
    let(:user){parent.user}
    before do
      do_login(user)
    end
    scenario "Parent renews registration and pays" do
      parent.students.each do|student|
        click_link "register_student_#{student.id}"
        do_fillin_registration_fields
        student.reload
      end
      click_link "pay"
      current_path.should == new_payment_path
      page.should have_content "Total Amount Due: $#{parent.current_unpaid_pending_registrations.count * 50}"
    end

    scenario "Parent has one new and old registration pays for new registration" do
      parent.students.each do|student|
        click_link "register_student_#{student.id}"
        do_fillin_registration_fields
        student.reload
      end
      current_path.should==parent_path(parent)
      do_create_new_student
      click_link "pay"
      current_path.should == new_payment_path
      page.should have_content "Total Amount Due: $#{parent.current_unpaid_pending_registrations.count * 50}"
    end

    scenario "Parent should not be able to pay for past registration" do
      page.should have_no_selector "pay"
    end

    scenario "Parent with old registrations creates new student registration can pay for new registration only" do
      do_create_new_student
      click_link "pay"
      current_path.should == new_payment_path
      page.should have_content "Total Amount Due: $#{50}"
    end

    scenario "Parent should only be charged for active registrations",:js => true  do
      student = parent.students.first
      click_link "student_id_#{student.id}"
      page.should have_content "Not Registered"
      click_link "new_registration"
      do_fillin_registration_fields
      user.reload
      parent.current_unpaid_pending_registrations.count.should == 1
      click_link "pay"
      do_pay_with_card
      page.should have_content("Payment Transaction Completed")
      current_path.should == payment_path(parent.payments.last)
      parent.reload.current_unpaid_pending_registrations.count.should == 0
    end
  end

  context "with current student registrations" do
    let(:parent){FactoryGirl.create(:parent_with_current_student_registrations)}
    let(:user){parent.user}
    scenario "Parent should not be able to pay for wait-list registration" do
      season = Season.current
      season.status = "Wait List"
      season.save
      do_login(user)
      page.should have_no_selector "pay"
    end

    scenario "Parent should not be able to pay for already paid-for registration" do
      parent.current_unpaid_pending_registrations.each do|reg|
        reg.confirmed_paid!
        reg.save
      end

      do_login(user)
      page.should have_no_selector "pay"
    end


    scenario "User checks out with card",:js => true  do
      do_login(user)
      click_link "pay"
      do_pay_with_card
      page.should have_content("Payment Transaction Completed")
      current_path.should == payment_path(parent.payments.last)
      parent.current_unpaid_pending_registrations.count.should == 0
    end

    scenario "User checks out with paypal", :js => true do
      FakeWeb.allow_net_connect = true
      do_login(user)
      click_link "pay"
      do_pay_with_paypal

      page.should have_content('Choose a way to pay')

      fill_in "login_email", :with => ENV['PAYPAL_BUYER']
      fill_in "login_password", :with =>ENV['PAYPAL_BUYER_PASSWORD']
      click_button "Log In"
      page.first("input[type='submit']").click
      page.should have_content("Payment Transaction Completed")
      parent.current_unpaid_pending_registrations.count.should == 0
    end

  end


end

