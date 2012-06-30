require 'spec_helper'

describe Season do
  it "should be valid" do
  season = Factory.create(:season)
  season.should be_valid
  end
end
