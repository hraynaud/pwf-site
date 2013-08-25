require 'spec_helper'

feature "register students Signup process" do

  context " new registration" do
    let(:user){FactoryGirl.create(:parent_user)}
    context "closed open enrollment" do
      before do
        disable_open_enrollment
        do_login(user)
      end

      scenario "Parent cannot register a new student unless open enrollment available", :focus => :failing do
        page.should_not have_link("new_registration")
      end

      scenario "Parent cannot visit new student reg unless open enrollment available", :focus => :failing do
        visit new_student_path
        current_path.should == parent_path(parent)
      end
    end

    context "open enrollment active" do
      before do
        do_login(user)
      end
      scenario "Parent Registers student" do
        do_create_new_student
        current_path.should == parent_path(parent)
        page.should have_content("Herby")
      end

      scenario "Parent Registers student with missing data" do
        click_link "new_registration"
        do_new_student_registraion_incomplete
        click_button "submit"
        current_path.should == students_path
      end
    end
  end

  context "Pre-existing registrations" do
    let(:user){FactoryGirl.create(:parent_user_with_old_student_registrations)}
    let(:student){parent.students.first}
    before do
      #student = parent.students.first
      do_login(user)
    end


    scenario "Parent renews a registration", :js=> true do
      current_path.should == parent_path(parent)
      click_link "student_id_#{student.id}"
      current_path.should == student_path(student)
      page.should have_content "Not Registered"
      click_link "new_registration"
      do_fillin_registration_fields
      student.reload
      current_path.should == parent_path(parent)
      page.should have_link("receipt_reg_id_#{student.current_registration.id}")
    end
    scenario "Parent renews a registration from show page link" do
      #parent = FactoryGirl.create(:parent_with_old_student_registrations)
      #student = parent.students.first
      #do_login(parent)
      current_path.should == parent_path(parent)
      click_link "register_student_#{student.id}"
      do_fillin_registration_fields
      student.reload
      current_path.should == parent_path(parent)
      page.should have_link("receipt_reg_id_#{student.current_registration.id}")
    end


    scenario "Parent renews a registration with missing_data then fixes problem" do
      #parent = FactoryGirl.create(:parent_with_old_student_registrations)
      #student = parent.students.first
      #do_login(parent)
      current_path.should == parent_path(parent)
      click_link "student_id_#{student.id}"
      current_path.should == student_path(student)
      page.should have_content "Not Registered"
      click_link "new_registration"
      current_path.should == new_student_registration_path
      fill_in "school", :with => "Hard Knocks"
      select  "L", :from => "Size"
      click_button "submit"
      current_path.should == student_registrations_path
      fill_in "grade", :with => "4"
      click_button "submit"
      student.reload
      page.should have_link("receipt_reg_id_#{student.current_registration.id}")
    end

    scenario "Parent renews a registration and is wait listed" do
      do_set_season_status("Wait List")
      current_path.should == parent_path(parent)
      click_link "student_id_#{student.id}"
      current_path.should == student_path(student)
      page.should have_content "Not Registered"
      click_link "new_registration"
      current_path.should == new_student_registration_path
      fill_in "school", :with => "Hard Knocks"
      fill_in "grade", :with => "4"
      select  "L", :from => "Size"
      click_button "submit"
      current_path.should == parent_path(parent)
      student.reload
      student.registration_status.should == "Wait List"
      page.should have_link("receipt_reg_id_#{student.current_registration.id}")
    end
  end

  context "Curent student registrations" do
    let(:user){FactoryGirl.create(:parent_user_with_current_student_registrations)}
    let(:student){parent.students.first}

    before do
      do_login(user)
    end
    scenario "Parent views confirmation of registration" do
      current_path.should == parent_path(parent)
      click_link "receipt_reg_id_#{student.current_registration.id}"
      current_path.should == confirmation_student_registration_path(student)
    end

    pending "Parent deletes current pending registration", :js => true do
      num_regs = parent.student_registrations.count
      current_path.should == parent_path(parent)
      page.should have_content student.first_name
      click_link "delete_student_registration_#{student.current_registration.id}"
      page.driver.browser.switch_to.alert.accept
      (parent.student_registrations(true)).count.should == num_regs -1
      current_path.should == parent_path(parent)
    end
    scenario "Parent cancels deletion of current pending registration", :js => true do
      num_regs = parent.student_registrations.count
      current_path.should == parent_path(parent)
      page.should have_content student.first_name
      click_link "delete_student_registration_#{student.current_registration.id}"
      page.driver.browser.switch_to.alert.dismiss
      (parent.student_registrations(true)).count.should == num_regs
      current_path.should == parent_path(parent)
    end

    scenario "Parent cannot delete confirmed registration" do
      do_logout
      student.current_registration.status = :confirmed_paid
      student.current_registration.save
      do_login(user)
      current_path.should == parent_path(parent)
      page.should have_content student.first_name
      page.should have_no_link "delete_student_registration_#{student.current_registration.id}"
      current_path.should == parent_path(parent)
    end

  end
  scenario "New Student Registration is wait listed if season is wait list" do
    user = FactoryGirl.create(:parent_user)
    do_set_season_status("Wait List")
    do_login(user)
    click_link "new_registration"
    current_path.should == new_student_path
    do_new_student_registration("Herby")
    click_button "submit"
    current_path.should == parent_path(user.profileable)
    page.should have_content("Herby")
    page.should have_content("Wait List")
  end



end
