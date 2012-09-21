require 'spec_helper'

describe ReportCard do
  it "should be valid" do
      rp = FactoryGirl.create(:report_card)
      rp.should be_valid
  end

  it "number grade should be valid" do
      rp = FactoryGirl.create(:number_grade_report)
      rp.should be_valid
  end

  it "A-F report should be valid" do
      rp = FactoryGirl.create(:A_to_F_letter_grade_report)
      rp.should be_valid
  end

  it "E-U should be valid" do
      rp = FactoryGirl.create(:E_to_U_letter_grade_report)
      rp.should be_valid
  end
end
