require 'spec_helper'

feature "AEP Registration", :focus => "aep" do
  let(:parent){FactoryGirl.create(:parent_with_current_student_registrations)}
  let(:student){parent.students.first}

  scenario "Parent cannot register student with unconfirmed registration" do
    do_login(parent.user)
    click_link "student_id_#{student.id}"
    asserts_no_aep_reg_link
  end

  context "New AEP Registration for confirmed students" do
    before do
      confirm_students
      do_login(parent.user)
      click_link "student_id_#{student.id}"
    end

    scenario "Parent Registers student", js:true do
      register_for_aep
      save_it
      asserts_successful_submission
    end

    scenario "Yes for disability no details provided " do
      register_for_aep
      clear_learning_disability_details
      save_it
      asserts_unsuccessful_submission
    end

    scenario "Yes for iep no details provided " do
      register_for_aep
      clear_iep_details
      save_it
      asserts_unsuccessful_submission
    end
  end

  context "student currently registered for aep" do
    before do
      confirm_students
      FactoryGirl.create_list(:workshop, 3)
      FactoryGirl.create(:paid_aep_registration, :student_registration =>student.current_registration)
      do_login(parent.user)
      click_link "student_id_#{student.id}"
    end

    scenario "Aep link not present if student currently registered for AEP" do
      asserts_no_aep_reg_link
    end

    pending "registers for workshop", :js => true, :focus=>:workshop do
      click_link "aep_profile"
      check Workshop.first.name
    end
  end


end

def register_for_aep
  click_link  "new_aep_registration"
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

def asserts_no_aep_reg_link
  page.should_not have_css("new_aep_registration") 
end

def asserts_successful_submission
  page.should have_content("successfully")
end
def asserts_unsuccessful_submission
  page.should_not have_content("successfully")
end
