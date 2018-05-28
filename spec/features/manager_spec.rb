require 'spec_helper'


RSpec.describe "AEP Manager" do
  let(:manager){FactoryGirl.create(:manager)}
  let!(:tutor){FactoryGirl.create(:tutor)}
  let!(:student_reg){FactoryGirl.create(:aep_registration)}

  before do
    %w(Math English Science).each {|s|FactoryGirl.create(:subject, :name => s)}
    FactoryGirl.create_list(:student, 5)
    do_login(manager.user)
  end

  it "Log in to dashboard" do
    current_path.should == dashboard_path
  end

  it "Create a tutor" do
    click_link "Tutors"
    click_link "New"
    tutor_user = FactoryGirl.build(:tutor_user)
    tutor = FactoryGirl.build(:tutor, :user => tutor_user)
    info = tutor.user.attributes
    fillin_user_fields "tutor", info
    fill_in "Occupation", :with => "College Student"
    save_it
    page.should have_content "Tutor successfully created"
  end

  it "Edit a tutor" do
    click_link "Tutors"
    click_link Tutor.first.name
    click_link "Edit"
    fill_in "Occupation", :with => "Grad Student"
    save_it
    page.should have_content "Tutor was successfully updated"
  end

  context "tutoring assignments" do
    it "create a new tutoring assignment" do
      click_link "Tutor Assignment"
      click_link "New"
      select tutor.name, :from => :tutoring_assignment_tutor_id
      select student_reg.student_name, :from => :tutoring_assignment_aep_registration_id
      select "Math", :from => :tutoring_assignment_subject_id
      save_it
      page.should have_content "Tutoring assignment was successfully created"
    end

  end

  context "Aep Registration" do
    before  do
      @student_reg =FactoryGirl.create(:paid_registration)
    end

  it "create current year registration", js:true do
      click_link "Aep Registration"
      within(".page-header") do
        page.should have_content Season.current.term
      end
      select Season.current.term, from: :season_id
      click_link "Add AEP Registration"
      select_from_chosen("aep_registration_student_registration_id_chosen", @student_reg.student_name)
      fillin_aep_reg_fields
      save_it
      asserts_successful_submission
   end

  end

  context "workshops" do
    it "create a new workshop" do
      click_link "Workshops"
      click_link "New"

      fill_in :workshop_name, :with => "Worky Worky"
      select tutor.name, :from => :workshop_tutor_id
      save_it
      page.should have_content "Workshop was successfully created"
    end

  end
end
