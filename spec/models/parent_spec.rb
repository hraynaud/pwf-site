require 'spec_helper'

describe Parent do
  it "valid with current demographic profile" do
    parent = FactoryBot.build(:parent_with_current_demographic_profile)
    expect(parent.valid?).to be true
  end

  describe "has_current_unpaid_fencing_registrations" do
    it "should be true if there are pending registrations" do
      parent = FactoryBot.create(:parent_with_current_student_registrations)
      parent.has_current_unpaid_fencing_registrations?.should be_true
    end
  end

  describe "current_unpaid_pending_registrations" do
    it "should show count of pending registrations" do
      parent = FactoryBot.create(:parent_with_current_student_registrations)
      parent.current_unpaid_pending_registrations.count.should == 2
    end
  end

end
