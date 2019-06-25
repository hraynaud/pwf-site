require 'spec_helper'

feature "register students Signup process " do

  context "new registration" do
    let(:parent){FactoryBot.create(:parent, :valid)}
    let(:user){parent}
    context "Registration not permitted" do
      before do
        do_login(user)
      end

      scenario "when open enrollment disabled", :focus => :failing do
        disable_open_enrollment
        visit new_student_path
       expect(current_path).to eq dashboard_path
      end

      scenario "if season closed" do
        close_season
        visit new_student_path
        expect(page).to have_css("#flash-alert")
       expect(current_path).to eq dashboard_path
      end

      scenario "New Student Registration is wait listed if season is wait list" do
        do_set_season_status(:wait_list)
        visit new_student_path
        do_new_student_registration("Herby")
        click_button "Create Student"
        expect(page).to have_content("Student and registration successfully created")
        expect(page).to have_content("Wait List")
      end
    end

    context "open enrollment active" do
      before do
        do_login(user)
      end
      scenario "Parent Registers student" do
        do_create_new_student
        expect(page).to have_css("#flash-notice")
      end

      scenario "Parent Registers student with missing data" do
        visit new_student_path
        do_new_student_registraion_incomplete
        click_button "submit"
        expect(page).to have_css("#flash-alert")
        expect(current_path).to eq students_path
      end
    end
  end

  context "Pre-existing registrations" do
    let(:parent){FactoryBot.create(:parent, :valid, :with_previous_student_registrations)}
    let(:user){parent}
    let(:student){parent.students.first}
    before do
      do_login(user)
    end


    scenario "Parent renews a registration" do
      click_link "Students"
      click_link "#{student.name}"
     expect(page).to have_content "Not Registered"
      click_link "Enroll"
      do_fillin_registration_fields
      expect(page).to have_content "Student registration successfully created"
    end

    scenario "Parent renews a registration with missing_data then fixes error" do
      click_link "Students"
      click_link "#{student.name}"
      expect(page).to have_content "Not Registered"
      click_link "Enroll"
      click_button "Submit"
      do_fillin_registration_fields
      expect(page).to have_content "Student registration successfully created"
    end

    scenario "Parent renews a registration and is wait listed" do
      do_set_season_status("wait_list")
      click_link "Students"
      click_link "#{student.name}"
      expect(page).to have_content "Not Registered"
      click_link "Enroll"
      do_fillin_registration_fields
      student.reload
      expect(student.registration_status).to eq "Wait List"
      expect(page).to have_content "Student registration successfully created"
    end
  end

  context "Curent student registrations" do
    let(:parent){FactoryBot.create(:parent, :valid, :with_current_student_registrations)}
    let(:user){parent}
    let(:student){parent.students.first}

    before do
      do_login(user)
    end


    scenario "Parent deletes current pending registration", :js => true do
      click_link "Students"
      click_link student.name 
      click_button "Cancel Enrollment" 
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content student.first_name
    end

    scenario "Parent cancels deletion of current pending registration", :js => true do
      click_link "Students"
      click_link student.name 
      click_button "Cancel Enrollment" 
      page.driver.browser.switch_to.alert.dismiss
      expect(page).to have_content student.first_name
    end

    scenario "Parent deletes confirmed registration" do
      student.current_registration.confirmed_paid!
      student.current_registration.save
      click_link "Students"
      click_link student.name 
      click_link "Withdraw" 

      expect(current_path).to eq withdraw_student_registration_path(student.current_registration)

      click_button "Submit" 
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content student.first_name
      expect(page).to have_content "Withdrawn"
    end

    #it "Parent views confirmation of registration" do
      #student.current_registration.confirmed_paid!
      #student.current_registration.save
      #click_link "Students"
      #click_link student.name 
      #click_link "Print Waiver" 
      #page.driver.browser.switch_to.window page.driver.browser.window_handles.last do
        #expect(current_path).to eq registration_confirmation_path(student.current_registration)
      #end
    #end
  end

end
