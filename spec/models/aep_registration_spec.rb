require 'spec_helper'

describe AepRegistration, :focus => :aep_fee do
  it "is is unpaid" do
    FactoryBot.create(:aep_registration )
    AepRegistration.current.unpaid.count.should eql 1
  end
  it "is is paid" do
    FactoryBot.create(:paid_aep_registration )
    AepRegistration.current.paid.count.should eql 1
  end
end
