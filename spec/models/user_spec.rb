require 'spec_helper'

describe User do
  pending "is not valid " do
    user = FactoryGirl.build(:parent_user)
    user.all_valid?.should be_false
  end

  pending "should be valid" do
  end


end
