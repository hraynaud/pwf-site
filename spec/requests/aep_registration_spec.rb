require 'spec_helper'

describe "AEP Registration", type: :feature do
  let(:parent){FactoryBot.create(:parent, :valid, :with_current_student_registrations)}
  let(:student){parent.students.first}


  scenario "Parent cannot register student with unconfirmed registration" do
    do_login(parent)
    click_link "Students"
    click_link "#{student.name}"
    asserts_no_aep_reg_link
  end

  context "New AEP Registration for confirmed students" do
    before do
      confirm_students
      do_login(parent)
      click_link "Students"
      click_link "#{student.name}"
    end

    scenario "Parent Registers student", js:true do
      register_for_aep
      click_button "Submit"
      asserts_successful_submission
    end

    scenario "Yes for disability no details provided " do
      register_for_aep
      clear_learning_disability_details
      click_button "Submit"
      asserts_unsuccessful_submission
    end

    scenario "Yes for iep no details provided " do
      register_for_aep
      clear_iep_details
      click_button "Submit"
      asserts_unsuccessful_submission
    end
  end

  context "student currently registered for aep" do

    scenario "Aep link not present if student currently registered for AEP" do
      confirm_students
      FactoryBot.create(:aep_registration, :paid, :student_registration =>student.current_registration)
      do_login(parent)
      click_link "Students"
      click_link "#{student.name}"
      asserts_no_aep_reg_link
    end

  end

  private

  def register_for_aep
    click_link  "Enroll Now"
    fillin_aep_reg_fields
  end

  def clear_iep_details
    fill_in "aep_registration_iep_details", :with => ""
  end

  def clear_learning_disability_details
    fill_in "aep_registration_learning_disability_details", :with => ""
  end

  def fillin_aep_reg_fields
    within("#learning_disability") do
      choose "Yes"
    end
    fill_in "aep_registration_learning_disability_details", :with => "He cray cray"
    within("#iep") do
      choose "Yes"
    end
    fill_in "aep_registration_iep_details", :with => "He cray cray"
  end

  def asserts_no_aep_reg_link
    expect(page).to_not have_content("Enroll Now") 
  end

  def asserts_unsuccessful_submission
    expect(page).to have_content("Please fix the highlighted errors below:")
  end

  def asserts_successful_submission
    expect(page).to have_content("You have 1 Pending payment for the AEP Program")
  end
end

