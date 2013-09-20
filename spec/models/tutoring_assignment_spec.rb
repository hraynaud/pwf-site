require 'spec_helper'

describe TutoringAssignment do

  it "is invalid without tutor and registred student", :focus => :ass do
    tut_ass =TutoringAssignment.new
    tut_ass.valid?.should be_false
  end


  it "is valid with tutor and aep_registatrion student", :focus => :ass do
    tut_ass =FactoryGirl.create(:tutoring_assignment)
    tut_ass.valid?.should be_true
  end


end
