
class Mgr::StudentRegistrationsController < InheritedResources::Base
 before_filter :for_season, :only=>[:index, :new, :create]

  def index
    @student_registrations = StudentRegistration.where(season_id: @season.id)
  end

end
