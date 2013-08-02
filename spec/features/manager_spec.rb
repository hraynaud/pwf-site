require 'spec_helper'


feature "AEP Manager" do
  let(:manager){FactoryGirl.create(:manager_user)}
  let(:tutor_user1){FactoryGirl.build(:tutor_user)}
  let!(:tutor){FactoryGirl.create(:tutor, :user => tutor_user1)}
  before do
    FactoryGirl.create_list(:student, 5)
    do_login(manager)
  end

  scenario "Log in to dashboard" do
    current_path.should == dashboard_path(manager)
  end

  scenario "Create a tutor" do
    click_link "Create Tutor"
    tutor = FactoryGirl.build(:tutor_user)
    info = tutor.attributes
    fillin_user_fields "tutor", info
    fill_in "Occupation", :with => "College Student"
    click_button "Save"
    current_path.should == dashboard_path(manager)
    page.should have_content "Tutors: 2"
  end

  scenario "Edit a tutor" do
    click_link "Tutor List"
    click_link Tutor.first.name
    fill_in "Occupation", :with => "Grad Student"
    click_button "Save"
    page.should have_content "Tutor successfully updated"
  end

  context "tutoring assignments" do
    scenario "create a new tutoring assignment" do
     
     click_link "Create tutoring assignment"
     select tutor.name, :from => "tutor"
     select Student.first.name, :from => :student
     select "Math", :from => :subject
     click_button "Save"
     page.should have_content "Assignment Created"
    end

  end


end
