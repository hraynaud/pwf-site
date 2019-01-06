require 'spec_helper'

feature "Process payments for a registration" do

  scenario "New Registration" do
    parent = FactoryBot.create(:parent, :valid)
    do_login(parent)
    do_create_new_student
    click_payment_link_for 1
    expect(current_path).to eq new_payment_path
    assert_correct_total_amount_for 1
  end

  context "2 previous registrations from past seasons" do
    #:with_previous_student_registrations creates 2

    let(:parent){FactoryBot.create(:parent, :valid, :with_previous_student_registrations)}
    let(:student){parent.students.first}
    before do
      do_login(parent)
    end

    scenario "Without registration renewal no pending payments" do
      assert_no_payment_link
    end

    scenario "Renews only one of the previous registrations",:js => true  do
      click_link "Students"
      click_link student.name
      expect(page).to have_content "Not Registered"
      click_link "Enroll Now"
      do_fillin_registration_fields
      click_payment_link_for 1
      assert_correct_total_amount_for 1
    end

    scenario "Parent renews  both registrations " do
      parent.students.each do|student|
        click_link "Students"
        click_link student.name
        click_link "Enroll Now"
        do_fillin_registration_fields
      end
      click_payment_link_for 2
      assert_correct_total_amount_for 2
    end

    scenario "Renews both previous registrations and creates a new one" do
      parent.students.each do|student|
        click_link "Students"
        click_link student.name
        click_link "Enroll Now"
        do_fillin_registration_fields
      end
      do_create_new_student
      click_payment_link_for 3
      assert_correct_total_amount_for 3
    end

    scenario "Creates a new registration without renewal" do
      do_create_new_student
      click_payment_link_for 1
      assert_correct_total_amount_for 1
    end

  end

  context "with current student registrations" do
    let(:parent){FactoryBot.create(:parent, :valid, :with_current_student_registrations)}
    scenario "Parent should not be able to pay for wait-list registration" do
      season = Season.current
      season.wait_list!
      season.save
      do_login(parent)
      assert_no_payment_link
    end

    scenario "Parent should not be able to pay for already paid-for registration" do
      parent.unpaid_registrations.each do|reg|
        reg.confirmed_paid!
        reg.save
      end
      do_login(parent)
      assert_no_payment_link
    end


    scenario "User checks out with card",:js => true  do
      do_login(parent)
      click_payment_link_for 2
      do_pay_with_card
      expect(page).to have_content("Payment Transaction Completed")
      expect(current_path).to eq payment_path(parent.payments.last)
      click_link "Dashboard"
      assert_no_payment_link
    end

  end

  def assert_correct_total_amount_for num_regs
    expect(page).to have_content "Total:\n$#{num_regs * fencing_fee}"
  end


  def assert_no_payment_link 
    expect(page).to_not have_content (/You have \d unpaid registrations/)
  end


  def click_payment_link_for num_regs
    click_link "You have #{num_regs} unpaid registrations"
  end

  def num_regs parent
    parent.unpaid_registrations_count
  end

  def fencing_fee
    @fee ||= Season.current.fencing_fee
  end

end

