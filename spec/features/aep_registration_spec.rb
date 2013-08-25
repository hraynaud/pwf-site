require 'spec_helper'

feature "AEP Registration", :focus => "aep" do
  let(:parent){FactoryGirl.create(:parent_with_current_student_registrations)}
  let(:student){parent.students.first}
  before do
    do_login(parent.user)
  end

  context "New confirmed student AEP Registration" do
    before do
      parent.current_unpaid_pending_registrations.each do|reg|
        reg.status = :confirmed_paid
        reg.save
      end
      click_link "student_id_#{student.id}"
    end
    scenario "Parent Registers student" do
      register_for_aep
      click_button "Submit"
      page.should have_content("successfully")
    end

    scenario "cannot register for AEP twice " do
      register_for_aep
      click_button "Submit"
      page.should have_not_content("successfully")
    end

    scenario "Yes for disability no details provided " do
      register_for_aep
      clear_learning_disability_details
      click_button "Submit"
      page.should_not have_content("successfully")
    end

    scenario "Yes for iep no details provided " do
      register_for_aep
      clear_iep_details
      click_button "Submit"
      page.should_not have_content("successfully")
    end
  end

  context "unregistered student" do
    scenario "Parent cannot register unenrolled student " do
      click_link "student_id_#{student.id}"
      page.should_not have_content("Register for AEP") 
    end
  end

  def register_for_aep
    click_link "Register for AEP"
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
end
