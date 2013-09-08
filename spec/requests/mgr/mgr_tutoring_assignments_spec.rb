require 'spec_helper'

describe "Mgr::TutoringAssignments" do
  describe "GET /mgr_tutoring_assignments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get mgr_tutoring_assignments_path
      response.status.should be(200)
    end
  end
end
