module ReportBehavior
  extend ActiveSupport::Concern

  included do
    belongs_to :tutor
    belongs_to :tutoring_assignment
    has_one :aep_registration, through: :tutoring_assignment
    has_one :student_registration, through: :aep_registration
    has_one :student, :through=> :student_registration

    attr_accessible :aep_registration_id, :tutor_id, :tutoring_assignment_id, :confirmed, :mgr_comments
    delegate :name, :to =>:student, :prefix=> true 
    delegate :name, :to =>:tutor, :prefix=> true 
    delegate :term, :to =>:aep_registration

  end

end
