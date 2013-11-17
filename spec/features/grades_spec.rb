require 'spec_helper'
feature "report cards and grades", js: true, focus: :grades do
  let!(:parent) {FactoryGirl.create(:parent_with_current_demographic_profile)}
  let!(:student) {FactoryGirl.create(:student, :parent=>parent)}
  let!(:student_reg) {FactoryGirl.create(:paid_registration, :student => student)}
  let!(:user) {parent.user} 

  before do
    %w(First Second Third).each {|i| MarkingPeriod.create!(name: i)}
    do_login user
  end

  scenario "Parent enter grades on a report card" do
      click_link "student_id_#{student.id}"
      click_link "Report cards"

      page.should have_css "#grades_table", :visible => false

      select student.name, from: "report_card[student_registration_id]"
      select "First", from: "report_card[marking_period]"
      select "A Plus To F", from: "report_card[format_cd]"
      accept_popup
      page.should have_css "#grades_table", :visible => true
  end

end

