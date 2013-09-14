class GradeConverter < ActiveRecord::Base
  attr_accessible :custom, :letter, :max, :min, :scale, :strategy
  belongs_to :grade_formats

 scope :by_letter_and_scale, ->(letter, scale){where(:letter =>letter, :scale => scale)}
end
