require "spec_helper"

describe GradeRanger, :focus => :grades do

  describe ".range_for" do
    it "produces a continuous range from 0 to 4" do
      GradeRanger.range_for(:four_point).should == (0..4)
    end

    it "produces a discrete range from A+ to F" do
      GradeRanger.range_for(:a_plus_to_f).should == %q(A+ A- A B+ B B- C+ C C- D+ D D- F)
    end
  end

  describe ".description_for" do
    it "produces a continuous range from 0 to 4" do
      GradeRanger.description_for(:four_point).should == "Four Point (ex: 0..4)"
    end

    it "produces a discrete range from A+ to F" do
      GradeRanger.description_for(:a_plus_to_f).should == "A Plus To F (ex: #{%q(A+ A- A B+ B B- C+ C C- D+ D D- F)})"
    end
  end

  describe ".for_select" do
    it "generates an array for select" do
      GradeRanger.for_select.should ==
      [["Four Point (ex: 0..4)", 0],
       ["Hundred Point (ex: 0..100)", 1],
       ["A To F (ex: A B C D F)", 2],
       ["A Plus To F (ex: A+ A- A B+ B B- C+ C C- D+ D D- F)", 3]]
    end
  end
end
