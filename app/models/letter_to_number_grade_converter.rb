class LetterToNumberGradeConverter < ActiveRecord::Base
  attr_accessible :custom, :letter, :max, :min, :scale, :strategy
end
