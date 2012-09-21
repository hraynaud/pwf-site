require 'spec_helper'

describe Grade do
  it "should be valid with student_registration_id" do
    grade = FactoryGirl.create(:grade)
    grade.valid?.should be_true
  end
end
