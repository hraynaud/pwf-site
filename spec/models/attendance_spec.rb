require 'spec_helper'

describe Attendance do

  it "should be valid" do
    attendance = FactoryGirl.create(:attendance)
    attendance.should be_valid
  end
end


