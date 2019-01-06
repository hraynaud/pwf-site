class CoParent < User
  has_many :co_parentships
  has_many :students, through: :co_parentships
  has_many :student_registrations, :through => :students

  scope :with_current_registrations, ->{
    joins(:students)
      .joins(:student_registrations)
      .merge(StudentRegistration.current).distinct
  }

end
