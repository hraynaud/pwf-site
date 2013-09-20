require 'spec_helper'

describe SessionReport, :focus => :tut do
  it "is invalid" do
   rep= SessionReport.new
   rep.valid?.should be_false
  end

  it "is valid with required fields" do
     rep = FactoryGirl.create(:valid_session_report)
     rep.valid?.should be_true
  end

end
