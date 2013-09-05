module ReportBehavior
  extend ActiveSupport::Concern

  included do
    belongs_to :tutor
    belongs_to :aep_registration
    belongs_to :tutor
    has_one :student_registration, :through=> :aep_registration
    has_one :student, :through=> :student_registration

    delegate :name, :to =>:student, :prefix=> true 
    delegate :name, :to =>:tutor, :prefix=> true 
    delegate :term, :to =>:aep_registration
  end
end
