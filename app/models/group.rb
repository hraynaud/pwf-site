class Group < ActiveRecord::Base
  attr_accessible :name, :instructor_id
  belongs_to :instructor
  delegate :name, to: :instructor, prefix: true
end
