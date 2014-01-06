class Ethnicity < ActiveRecord::Base
  attr_accessible :title
  has_many :students
end
