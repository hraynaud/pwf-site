class GradeConverter < ActiveRecord::Base
  belongs_to :grade_formats

 scope :by_letter_and_scale, ->(letter, scale){where(:letter =>letter, :scale => scale)}
end
