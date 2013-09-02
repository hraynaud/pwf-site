require 'spec_helper'

feature "tutor behavior", :js=>true, :focus => :tut do
  let(:tutor){FactoryGirl.create(:tutor)}
  let!(:aep_reg){FactoryGirl.create(:complete_aep_registration)}
  let(:student){aep_reg.student}
  before do
    FactoryGirl.create(:tutoring_assignment, :tutor => tutor, :aep_registration => aep_reg)
    do_login(tutor.user)
    current_path.should == dashboard_path
  end

  scenario "create a new valid session report" do
    click_link "Create new session report"
    pick_date
    fill_in_form
    click_button "Save"
    page.should have_content "Session report successfully saved"
  end

  scenario "invalid session report" do
    click_link "Create new session report"
    fill_in_form
    click_button "Save"
    page.should have_content "Please review the following problems"
  end

  scenario "confirm session report" do
    click_link "Create new session report"
    pick_date
    sleep 1
    fill_in_form
    check "Finalize and Confirm?"
    click_button "Save"
    page.should have_content "Session Report Save And Finalized"
  end

  def pick_date
    page.execute_script('$(".datepicker").trigger("focus")') 
    page.execute_script('$("td.day:contains(15)").trigger("click")')
  end

  def fill_in_form
    select student.name, :from => "Student"
    select "Homework assistance", :from =>"Worked on"
    select "Well prepared", :from =>"Preparation"
    select "Excellent", :from =>"Participation"
    select "Excellent", :from =>"Comprehension"
    select "Excellent", :from =>"Motivation"
  end

  

end


