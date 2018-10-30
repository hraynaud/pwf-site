require "spec_helper"

describe GradeConversionService, :focus => :grades do

  describe ".range_for" do
    it "produces a continuous range from 0 to 4" do
      expect(GradeConversionService.range_for(:four_point)).to eq (0..4)
    end

    it "produces a discrete range from A+ to F" do
      expect(GradeConversionService.range_for(:a_plus_to_f)).to eq %w(A+ A- A B+ B B- C+ C C- D+ D D- F)
    end
  end

  describe ".description_for" do
    it "produces a description 4 point scale" do
     expect(GradeConversionService.description_for(:four_point)).to eq "Four Point"
    end

    it "produces a description for  A+ to F" do
      expect(GradeConversionService.description_for(:a_plus_to_f)).to eq "A Plus To F"
    end
  end

  describe ".for_select" do
    it "generates an array for select" do
      expect(GradeConversionService.for_select).to eq([["Four Point", 0], ["Hundred Point", 1],
       ["A Plus To F", 2]])
    end
  end

  describe ".range_by_format_index" do
    it "produces a discrete range from A+ to F" do
      expect(GradeConversionService.range_by_format_index(0)).to eq (0..4)
    end
  end
end
