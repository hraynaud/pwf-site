class AepAttendance < ActiveRecord::Base
  belongs_to :aep_session
  belongs_to :aep_registration

  validates_uniqueness_of :aep_registration_id, scope: :aep_session_id
  scope :present, -> {where(attended: true)}

end
