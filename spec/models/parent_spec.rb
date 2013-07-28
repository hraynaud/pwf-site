require 'spec_helper'

describe Parent do
  it "is invalid without current demographic profile" do
    parent = FactoryGirl.create(:parent)
    parent.valid?.should be_false
  end

  it "valid with current demographic profile" do
    parent = FactoryGirl.build(:parent_with_current_demographic_profile)
    parent.save
    parent.valid?.should be_true
  end

  it "should be invalid if associated demographic is invalid" do
    parent = FactoryGirl.build(:parent_with_invalid_demographics )
    parent.save
    parent.valid?.should be_false
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
