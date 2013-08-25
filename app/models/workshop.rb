class Workshop < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student_registrations 
  has_many :students, :through => :student_registrations
  attr_accessible :name, :notes, :tutor_id, :stuent_registration_id
end
