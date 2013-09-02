require 'spec_helper'

feature "tutor behavior",:js=>true, :focus => :tut do
  let(:tutor){FactoryGirl.create(:tutor)}
  let!(:aep_reg){FactoryGirl.create(:complete_aep_registration)}
  let(:student){aep_reg.student}
  let(:assignment){FactoryGirl.create(:tutoring_assignment, :tutor => tutor, :aep_registration => aep_reg)}
  context "session reports" do
    context "New report"  do
      before do
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
        page.should have_content "Please review the problems below"
      end
    end

    context "existing session report" do
      context "unconfirmed" do
        let!(:rep){FactoryGirl.create(:valid_session_report)}
        before do
          do_login(tutor.user)
        end
        scenario "confirm session report" do
          click_link "Session Reports"
          click_link rep.student_name
          check "Finalize and Confirm?"
          click_button "Save"
          accept_popup
          page.should have_content "Report Confirmed and Finalized"
        end

        scenario "Cancels confirm report" do
          click_link "Session Reports"
          click_link rep.student_name
          check "Finalize and Confirm?"
          click_button "Save"
          cancel_popup
          page.should_not have_content "Report Confirmed and Finalized"
        end

        scenario "edit session report" do
          click_link "Session Reports"
          click_link rep.student_name
          current_path.should == edit_session_report_path(rep)
        end

      end
      context "confirmed" do
        scenario "edit session report" do
          rep = FactoryGirl.create(:confirmed_session_report)
          do_login(tutor.user)
          click_link "Session Reports"
          click_link rep.student_name
          current_path.should == session_report_path(rep)
        end
      end
    end
  end

  #context "monthly reports" do
  #context "New report" , :js=>true do
  #before do
  #do_login(tutor.user)
  #current_path.should == dashboard_path
  #end

  #scenario "create a new valid session report" do
  #click_link "Create new monthly report"
  #fill_in_monthly_form
  #click_button "Save"
  #page.should have_content "Session report successfully saved"
  #end

  #scenario "invalid monthly report" do
  #click_link "Create new monthly report"
  #fill_in_monthly_form
  #click_button "Save"
  #page.should have_content "Please review the problems below"
  #end

  #end

  #context "confirmed session report" do
  #let(rep){FactoryGirl.create(:valid_session_report)}
  #scenario "confirm monthly report" do
  #click_link "Create new session report"
  #pick_date
  #fill_in_form
  #check "Finalize and Confirm?"
  #click_button "Save"
  #accept_popup
  #page.should have_content "Report Confirmed and Finalized"
  #end

  #scenario "Cancels confirm report" do
  #click_link "Create new session report"
  #pick_date
  #fill_in_form
  #check "Finalize and Confirm?"
  #click_button "Save"
  #cancel_popup
  #page.should_not have_content "Report Confirmed and Finalized"
  #end
  #scenario "edit session report" do
  #rep = FactoryGirl.create(:valid_session_report)
  #do_login(tutor.user)
  #click_link "Session Reports"
  #click_link rep.student_name
  #current_path.should == edit_session_report_path(rep)
  #end


  #scenario "edit session report" do
  #rep = FactoryGirl.create(:confirmed_session_report)
  #do_login(tutor.user)
  #click_link "Session Reports"
  #click_link rep.student_name
  #current_path.should == session_report_path(rep)
  #end
  #end
  #end



  def pick_date
    page.execute_script('$(".datepicker").trigger("focus")') 
    sleep 0.5 #needed to ensure jquery finishes. TODO investigate
    page.execute_script('$("td.day:contains(15)").trigger("click")')
    sleep 0.5 #needed to ensure jquery finishes. TODO investigate
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


