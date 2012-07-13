require 'spec_helper'

feature "Process payments for a registration" do

  scenario " Happy day parent registers and pays for registration" do
    @parent = FactoryGirl.create(:complete_parent)
    do_login(@parent)
    do_create_new_student
    click_link "pay_registration"
    current_path.should == new_payment_path
    page.should have_content "Total Amount: $#{@parent.current_unpaid_pending_registrations.count * 50}"
  end

  scenario "Parent renews registration and pays" do
    @parent = FactoryGirl.create(:parent_with_old_student_registrations)
    do_login(@parent)
    @parent.students.each do|student|
      click_link "register_student_#{student.id}"
      do_fillin_registration_fields
      student.reload
    end
    click_link "pay_registration"
    current_path.should == new_payment_path
    page.should have_content "Total Amount: $#{@parent.current_unpaid_pending_registrations.count * 50}"
  end

  scenario "Parent has one new and old registration pays for new registration" do
    @parent = FactoryGirl.create(:parent_with_old_student_registrations)
    do_login(@parent)
    @parent.students.each do|student|
      click_link "register_student_#{student.id}"
      do_fillin_registration_fields
      student.reload
    end
    current_path.should==parent_path(@parent)
    do_create_new_student
    click_link "pay_registration"
    current_path.should == new_payment_path
    page.should have_content "Total Amount: $#{@parent.current_unpaid_pending_registrations.count * 50}"
  end

  scenario "Parent should not be able to pay for past registration" do
    @parent = FactoryGirl.create(:parent_with_old_student_registrations)
    do_login(@parent)
    page.should have_no_selector "pay_registration"
  end

  scenario "Parent with old registrations creates new student registration can pay for new registration only" do
    @parent = FactoryGirl.create(:parent_with_old_student_registrations)
    do_login(@parent)
    do_create_new_student
    click_link "pay_registration"
    current_path.should == new_payment_path
    page.should have_content "Total Amount: $#{50}"
  end

  scenario "Parent should not be able to pay for wait-list registration" do
    season = Season.current
    season.status = "Wait List"
    season.save
    @parent = FactoryGirl.create(:parent_with_current_student_registrations)
    do_login(@parent)
    page.should have_no_selector "pay_registration"
  end

  scenario "Parent should not be able to pay for already paid-for registration" do
    @parent = FactoryGirl.create(:parent_with_current_student_registrations)
    @parent.current_unpaid_pending_registrations.each do|reg|
      reg.status = "Confirmed Paid"
      reg.save
    end

    do_login(@parent)
    page.should have_no_selector "pay_registration"
  end
end
