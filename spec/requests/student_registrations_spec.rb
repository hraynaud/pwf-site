require 'spec_helper'

feature "register students Signup process" do

  scenario "Parent Registers student" do
    parent = FactoryGirl.create(:complete_parent)
    do_login(parent)
    click_link "new_registration"
    current_path.should == new_student_path
    do_new_student_registration("Herby")
    click_button "submit"
    current_path.should == parent_path(parent)
    page.should have_content("Herby")
  end

  scenario "Parent Registers student with missing data" do
    parent = FactoryGirl.create(:complete_parent)
    do_login(parent)
    click_link "new_registration"
    do_new_student_registraion_incomplete
    click_button "submit"
    current_path.should == students_path
  end

  scenario "Parent renews a registration" do
    parent = FactoryGirl.create(:parent_with_old_student_registrations)
    student = parent.students.first
    do_login(parent)
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
    page.should have_link("receipt_reg_id_#{student.current_registration.id}")
  end

 scenario "Parent renews a registration with missing_data then fixes problem" do
    parent = FactoryGirl.create(:parent_with_old_student_registrations)
    student = parent.students.first
    do_login(parent)
    current_path.should == parent_path(parent)
    click_link "student_id_#{student.id}"
    current_path.should == student_path(student)
    page.should have_content "Not Registered"
    click_link "new_registration"
    current_path.should == new_student_registration_path
    fill_in "school", :with => "Hard Knocks"
    select  "L", :from => "Size"
    click_button "submit"
    save_and_open_page
    current_path.should == student_registrations_path
    fill_in "grade", :with => "4"
    click_button "submit"
    student.reload
    page.should have_link("receipt_reg_id_#{student.current_registration.id}")
  end

  scenario "Parent views confirmation of registration" do
    parent = FactoryGirl.create(:parent_with_current_student_registrations)
    student = parent.students.first
    do_login(parent)
    current_path.should == parent_path(parent)
    click_link "receipt_reg_id_#{student.current_registration.id}"
    current_path.should == confirmation_student_registration_path(student)
  end




end
