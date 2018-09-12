require 'spec_helper'

describe ReportCard do
  it "should be valid" do
    expect(FactoryBot.create(:report_card).valid?).to be true
  end

  it "number grade should be valid" do
    expect(FactoryBot.create(:number_grade_report).valid?).to be true
  end

  it "A-F report should be valid" do
       expect(FactoryBot.create(:A_to_F_letter_grade_report).valid?).to be true
  end

  it "E-U should be valid" do
       expect(FactoryBot.create(:E_to_U_letter_grade_report).valid?).to be true
  end

  describe "#reassign_to_last_season" do

    let(:student){FactoryBot.create(:student)}
    let(:reg_curr){FactoryBot.create(:student_registration, season: Season.current, student: student, status: :confirmed_paid)}
    let(:card){FactoryBot.create(:report_card, season: Season.current, student_registration: reg_curr)}

    context "student has previous registration" do
      it "should reassigns report card to previous season attended" do
        reg_prev = FactoryBot.create(:student_registration, season: Season.previous,  student: student, status: :wait_list)
        card.reassign_to_last_season
        expect(card.student_registration).to eq reg_prev
        expect(card.season).to eq Season.previous
      end
    end

    context "student has no previous registration" do
      it "should reassigns report card to previous season attended" do
        card.reassign_to_last_season
        expect(card.student_registration).to eq reg_curr
        expect(card.season).to eq Season.current
      end
    end
  end
end