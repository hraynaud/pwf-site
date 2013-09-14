require 'spec_helper'

describe Grade, :focus => :grades do
  describe "normalize" do
    grade = FactoryGirl.build(:a_f_grade)
    grade.normalize_to_hundred_point.should ==100
  end
end
