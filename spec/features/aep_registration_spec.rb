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

