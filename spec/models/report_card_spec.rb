require 'spec_helper'

describe ReportCard do
  pending "should be valid" do
      rp = FactoryBot.create(:report_card)
      rp.should be_valid
  end

  pending "number grade should be valid" do
      rp = FactoryBot.create(:number_grade_report)
      rp.should be_valid
  end

  pending "A-F report should be valid" do
      rp = FactoryBot.create(:A_to_F_letter_grade_report)
      rp.should be_valid
  end

  pending "E-U should be valid" do
      rp = FactoryBot.create(:E_to_U_letter_grade_report)
      rp.should be_valid
  end


  describe "#reassign_to_last_season" do
    it "should set report card back" do
      s = FactoryBot.create(:student)
      s1 = FactoryBot.create(:season)
      s2 = FactoryBot.create(:season)

     r1 = FactoryBot.create(:student_registration, student: s)
     r2 = FactoryBot.create(:student_registration, student: s)

      rp = FactoryBot.create(:report_card, student_registration:r2)
    end
  end
end
