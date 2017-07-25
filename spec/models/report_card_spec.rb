require 'spec_helper'

describe ReportCard do
  pending "should be valid" do
      rp = FactoryGirl.create(:report_card)
      rp.should be_valid
  end

  pending "number grade should be valid" do
      rp = FactoryGirl.create(:number_grade_report)
      rp.should be_valid
  end

  pending "A-F report should be valid" do
      rp = FactoryGirl.create(:A_to_F_letter_grade_report)
      rp.should be_valid
  end

  pending "E-U should be valid" do
      rp = FactoryGirl.create(:E_to_U_letter_grade_report)
      rp.should be_valid
  end


  describe "#reassign_to_last_season" do
    it "should set report card back" do
      s = FactoryGirl.create(:student)
      s1 = FactoryGirl.create(:season)
      s2 = FactoryGirl.create(:season)

     r1 = FactoryGirl.create(:student_registration, student: s)
     r2 = FactoryGirl.create(:student_registration, student: s)

      rp = FactoryGirl.create(:report_card, student_registration:r2)
    end
  end
end
