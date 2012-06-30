class StudentRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :student
  attr_accessible :school, :grade, :size_cd, :medical_notes, :academic_notes, :academic_assistance

  validates :season, :school, :grade, :size_cd, :presence => :true

  SIZES = %w(Kids\ xs Kids\ S Kids\ M Kids\ L S M L XL 2XL 3XL)
  as_enum :size, SIZES.each_with_index.inject({}) {|h, (item,idx)| h[item]=idx; h}

  as_enum :status, ["Pending", "Pending Paid", "Confirmed", "Confirmed Paid"]
  scope :current, where(:current => true)

  def active?
    season.is_current?
  end

end