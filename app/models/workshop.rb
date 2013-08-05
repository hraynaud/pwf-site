class Workshop < ActiveRecord::Base
  belongs_to :tutor
  has_many :student_registrations 
  has_many :students 
  attr_accessible :name, :notes, :tutor_id
end
