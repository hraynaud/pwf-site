require 'spec_helper'

describe Season do
  it "should be valid" do
    season = FactoryBot.create(:season)
    season.should be_valid
  end

  describe "#open_enrollment_enabled" do
    it "it is false if enrollment in future" do
      season = FactoryBot.create(:season)
      season.open_enrollment_date = 2.months.from_now
      season.open_enrollment_enabled.should be_false
    end

    it "it is true if enrollment in past" do
      season = FactoryBot.create(:season)
      season.open_enrollment_date = 1.months.ago
      season.open_enrollment_enabled.should be_true
    end
  end

  describe "is_current?" do
   it "is false if outside of range" do

   end
  end
end
