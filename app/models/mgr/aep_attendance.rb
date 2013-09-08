class Mgr::AepAttendance < ActiveRecord::Base
  attr_accessible :AepAttendance, :aep_registration_id, :aep_session_id, :season_id
end
