require 'spec_helper'

describe Parent do
  it "should be valid" do
    parent = FactoryGirl.create(:parent)
    parent.valid?(:create).should be_true
    parent.registration_complete?.should be_false
  end

  it "should be valid" do
    parent = FactoryGirl.create(:complete_parent)
    parent.valid?(:create).should be_true
    parent.registration_complete?.should be_true
  end

  describe "has_unpaid_pending_registrations" do
    it "should say yes if there are pending registrations" do
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
