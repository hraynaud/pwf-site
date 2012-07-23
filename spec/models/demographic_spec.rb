require 'spec_helper'

describe Demographic do
  it "should be valid" do
    demographics = FactoryGirl.create(:demographic)
    demographics.should be_valid
  end


  it "should be invalid" do
    demographics = FactoryGirl.build(:no_season_demographics)
    demographics.should be_valid
  end
end
