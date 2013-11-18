require 'spec_helper'

feature "tutor behavior",:js=>true , :focus => :tut do

  let(:tutor){FactoryGirl.create(:tutor)}
  let!(:aep_reg){FactoryGirl.create(:complete_aep_registration)}

  let!(:assignment){FactoryGirl.create(:tutoring_assignment, :tutor => tutor, :aep_registration => aep_reg)}
  let(:student){aep_reg.student}

  let(:manager){FactoryGirl.create(:manager)}

  context "session reports" do

    context "New" do

      before do
    do_login(manager.user)
      end

      scenario "create a new valid session report" do
        click_link "Session"
        click_link "New"
        fill_in_session_form
        pick_date
        save_it
        assert_report_saved
      end

      scenario "invalid session report" do
        click_link "Session"
        click_link "New"
        fill_in_session_form
        save_it
        assert_errors
      end
    end

    context "unconfirmed" do
      let!(:rep){FactoryGirl.create(:valid_session_report, :tutor => tutor, :tutoring_assignment => assignment)}
      before(:each) do
        do_login(manager.user)
      end

     scenario "Ok's Confirm" do
      click_link "Session"
      find_and_confirm_report
      accept_popup
      assert_report_finalized
    end

    scenario "Cancels confirm" do
      click_link "Session"
      find_and_confirm_report
      cancel_popup
      page.should_not have_content "Report successfully confirmed and finalized"
    end
  end

  context "confirmed" do
    scenario "edit redirects to finalized report" do
      rep = FactoryGirl.create(:confirmed_session_report, :tutor => tutor, :tutoring_assignment => assignment)
      do_login(manager.user)
      visit edit_mgr_session_report_path(rep)
      current_path.should == mgr_session_report_path(rep)
    end
  end
end


context "monthly reports"  do
  context "New report"  do
    before do
      do_login(manager.user)
    end

    scenario "create a new valid monthly report" do
      click_link "Monthly"
      click_link "New"
      fill_in_monthly_form
      save_it
      assert_report_saved
    end

    scenario "invalid monthly report" do
      click_link "Monthly"
      click_link "New"
      fill_in_monthly_form
      fill_in "Progress notes", :with => "" 
      save_it
    end
  end

  context "when existing monthly report" do
    context "is unconfirmed" do
      let!(:rep){FactoryGirl.create(:valid_monthly_report, :tutor => tutor,  :tutoring_assignment => assignment)}
      before do
        do_login(manager.user)
      end
      scenario "confirm monthly report" do
      click_link "Monthly"
        find_and_confirm_report
        accept_popup
        assert_report_finalized
      end

      scenario "Cancels confirm report" do
      click_link "Monthly"
        find_and_confirm_report
        cancel_popup
        page.should_not have_content "Report Confirmed and Finalized"
      end

    end
    context "when confirmed" do
      scenario "edit redirects to finalized report" do
        rep = FactoryGirl.create(:confirmed_monthly_report, :tutor => tutor, :tutoring_assignment => assignment)
        do_login(manager.user)
        visit edit_mgr_monthly_report_path(rep)
        current_path.should == mgr_monthly_report_path(rep)
      end
    end
  end
end

context "Year End reports"  do
  context "New report"  do
    before do
      do_login(manager.user)
    end

    scenario "create a new valid year end report" do
      click_link "Year End"
      click_link "New"
      fill_in_year_end_form
      save_it
      assert_report_saved
    end

    scenario "invalid year end report" do
      click_link "Year End"
      click_link "New"
      fill_in_year_end_form
      fill_in "Attendance", :with => "" 
      save_it
    end
  end

  context "when existing year end report" do
    context "is unconfirmed" do
      let!(:rep){FactoryGirl.create(:valid_year_end_report, :tutor => tutor, :tutoring_assignment => assignment)}
      before do
        do_login(manager.user)
      end
      scenario "confirm year end report" do
        click_link "Year End"
        find_and_confirm_report
        accept_popup
        assert_report_finalized
      end

      scenario "Cancels confirm report" do
        click_link "Year End"
        find_and_confirm_report
        cancel_popup
        page.should_not have_content "successfully"
      end

    end
    context "when confirmed" do
      scenario "edit redirects to finalized report" do
        rep = FactoryGirl.create(:confirmed_year_end_report, :tutor => tutor, :tutoring_assignment => assignment)
        do_login(manager.user)
        visit edit_mgr_year_end_report_path(rep)
        current_path.should == mgr_year_end_report_path(rep)
      end
    end
  end
  end

  def find_and_confirm_report
    click_link rep.name
    click_link "Edit"
    check "Finalize and Confirm?"
    save_it
  end

  def pick_date
    page.execute_script('$("input.datepicker").trigger("focus")')
    page.execute_script('$("td.day:contains(15)").trigger("click")')
  end

  def fill_in_session_form
    select_from_chosen "session_report_tutoring_assignment_id_chosen", "#{student.name} > #{tutor.name}"
    select "Homework assistance", :from =>"Worked on"
    select "Well prepared", :from =>"Preparation"
    select "Excellent", :from =>"Participation"
    select "Excellent", :from =>"Comprehension"
    select "Excellent", :from =>"Motivation"
  end


  def fill_in_monthly_form

    select_from_chosen "monthly_report_tutoring_assignment_id_chosen", "#{student.name} > #{tutor.name}"
    select "October", :from => "Month"
    fill_in "Num hours with student", :with => 10
    fill_in "Num preparation hours", :with => 10
    fill_in "Student goals", :with => "blah blah"
    choose "monthly_report_goals_achieved_false"
    fill_in "Progress notes", :with => "blah blah" 
    choose "monthly_report_new_goals_set_false"
    fill_in "New goals desc", :with => "Something Else"
    fill_in "Issues concerns", :with => "He Cray Cray"
    fill_in "Issues resolution", :with =>",Lock him up"
  end

  def fill_in_year_end_form
    select_from_chosen "year_end_report_tutoring_assignment_id_chosen", "#{student.name} > #{tutor.name}"
    fill_in "Attendance", :with =>"blah" 
    fill_in "Preparation", :with => "blase blase" 
    fill_in "Participation", :with => "blah blah"
    fill_in "Academic skills", :with => "blah blah" 
    fill_in "Challenges concerns", :with => "Something Else"
    fill_in "Achievements", :with => "He Cray Cray"
    fill_in "Recommendations", :with =>",Lock him up"
    fill_in "Comments", :with =>"Lock him up"
  end

end


