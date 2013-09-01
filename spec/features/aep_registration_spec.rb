require 'spec_helper'

feature "AEP Registration", :focus => "aep" do
  let(:parent){FactoryGirl.create(:parent_with_current_student_registrations)}
  let(:student){parent.students.first}

  context "New confirmed student AEP Registration" do
    before do
      confirm_students
      do_login(parent.user)
      click_link "student_id_#{student.id}"
    end

    scenario "Parent Registers student" do
      register_for_aep
      click_button "Submit"
      page.should have_content("successfully")
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

  context "student currently registered for aep" do
    before do
      confirm_students
      FactoryGirl.create(:aep_registration, :student_registration =>student.current_registration)
      do_login(parent.user)
    end
    scenario "Aep link not present if student currently registered for AEP" do
      page.should_not have_content("Register for AEP")
    end
  end


  context "Unconfirmed general program registration" do
    before do
      do_login(parent.user)
    end
    scenario "Parent cannot register unenrolled student " do
      click_link "student_id_#{student.id}"
      page.should_not have_content("Register for AEP") 
    end
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

def confirm_students
  parent.current_unpaid_pending_registrations.each do|reg|
    reg.status = :confirmed_paid
    reg.save
  end
end
