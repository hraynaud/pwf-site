require 'spec_helper'

describe User do
  it "is not valid " do
    user = FactoryGirl.build(:user)
    user.all_valid?.should be_false
  end

  it "should be valid" do
    user = FactoryGirl.create(:complete_user)
    user.all_valid?.should be_true
  end


end
