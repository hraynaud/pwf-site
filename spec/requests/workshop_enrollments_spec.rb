require 'spec_helper'

describe "WorkshopEnrollments" do
  describe "GET /workshop_enrollments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get workshop_enrollments_path
      response.status.should be(200)
    end
  end
end
