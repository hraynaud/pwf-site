require 'spec_helper'


feature "AEP Manager" do
  let(:manager){FactoryGirl.create(:manager_user)}
  let(:tutor_user1){FactoryGirl.build(:tutor_user)}
  let!(:tutor){FactoryGirl.create(:tutor, :user => tutor_user1)}
  let!(:student_reg){FactoryGirl.create(:aep_registration)}

  before do
    %w(Math English Science).each {|s|FactoryGirl.create(:subject, :name => s)}
    FactoryGirl.create_list(:student, 5)
    do_login(manager)
  end

  scenario "Log in to dashboard" do
    current_path.should == dashboard_path
  end

  scenario "Create a tutor" do
    click_link "Create Tutor"
    tutor = FactoryGirl.build(:tutor_user)
    info = tutor.attributes
    fillin_user_fields "tutor", info
    fill_in "Occupation", :with => "College Student"
    save_it
    page.should have_content "Tutors: 2"
  end

  scenario "Edit a tutor" do
    click_link "Tutor List"
    click_link Tutor.first.name
    click_link "Edit"
    fill_in "Occupation", :with => "Grad Student"
    save_it
    page.should have_content "Tutor successfully updated"
  end

  context "tutoring assignments" do
    scenario "create a new tutoring assignment" do
      click_link "Create tutoring assignment"
      select tutor.name, :from => :tutoring_assignment_tutor_id
      select student_reg.student_name, :from => :tutoring_assignment_aep_registration_id
      select "Math", :from => :tutoring_assignment_subject_id
      save_it
      page.should have_content "Tutoring assignment was successfully created"
    end

  end

  context "workshops" do
    scenario "create a new workshop" do
      click_link "Create workshop"
      fill_in :workshop_name, :with => "Worky Worky"
      select tutor.name, :from => :workshop_tutor_id
      save_it
      page.should have_content "Workshop was successfully created"
    end

  end
end

