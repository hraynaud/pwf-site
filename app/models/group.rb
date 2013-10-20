class Group < ActiveRecord::Base
  attr_accessible :name, :instructor_id
  belongs_to :instructor
  has_many :student_registrations
  has_many :students, through: :student_registrations
  delegate :name, to: :instructor, prefix: true


  def self.group_list
   self.all.map{|g| {name: g.name, id: g.id, instructorId: g.instructor_id}}.push({name:"Unassigned", id:"-1"})
  end
end
