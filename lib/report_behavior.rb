module ReportBehavior
  extend ActiveSupport::Concern

  included do
    belongs_to :tutor
    belongs_to :aep_registration
    belongs_to :tutoring_assignment
    has_one :student_registration, :through=> :aep_registration
    has_one :student, :through=> :student_registration
    attr_accessible :aep_registration_id, :tutoring_assignment_id, :tutor_id, :confirmed, :mgr_comments
    delegate :name, :to =>:student, :prefix=> true 
    delegate :name, :to =>:tutor, :prefix=> true 
    delegate :term, :to =>:aep_registration

    before_save :set_aep_registration_id
  end

  def set_aep_registration_id
     self.aep_registration_id = tutoring_assignment.aep_registration_id
  end
end
