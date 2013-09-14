require 'spec_helper'

describe "Mgr::MarkingPeriods" do
  describe "GET /mgr_marking_periods" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get mgr_marking_periods_path
      response.status.should be(200)
    end
  end
end
