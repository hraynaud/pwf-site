require 'spec_helper'

describe Demographics do
  it "should be valid" do
    demographics = FactoryGirl.create(:demographics)
    demographics.should be_valid
  end


  it "should be invvalid" do
    demographics = FactoryGirl.build(:no_season_demographics)
    demographics.should be_invalid
  end
end
