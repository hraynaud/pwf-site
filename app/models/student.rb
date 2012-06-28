class Student < ActiveRecord::Base
  has_many :student_registrations
  belongs_to :parent

  attr_accessible :first_name, :last_name, :gender, :dob
  validates :first_name, :last_name, :gender, :dob, :presence => :true

  def name
    "#{first_name} #{last_name}"
  end
end

