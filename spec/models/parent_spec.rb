require 'spec_helper'

describe Parent do
  it "should not be valid" do
    parent = FactoryGirl.build(:parent)
    parent.all_valid?.should be_false
  end

  it "should be invalid when season is nil on assocaiated demographic" do
    parent = FactoryGirl.build(:parent_with_no_season_demographics )
    parent.all_valid?.should be_false
  end

  it "should be invalid if associated demographic is invalid" do
    parent = FactoryGirl.build(:parent_with_invalid_demographics )
    parent.all_valid?.should be_false
  end

  it "should be valid" do
    parent = FactoryGirl.create(:complete_parent)
    parent.all_valid?.should be_true
    parent.registration_complete?.should be_true
  end

  describe "has_unpaid_pending_registrations" do
    it "should be true if there are pending registrations" do
      parent = FactoryGirl.create(:parent_with_current_student_registrations)
      parent.has_unpaid_pending_registrations?.should be_true
    end
  end

  describe "current_unpaid_pending_registrations" do
    it "should show count of pending registrations" do
      parent = FactoryGirl.create(:parent_with_current_student_registrations)
      parent.current_unpaid_pending_registrations.count.should == 2
    end
  end

end
