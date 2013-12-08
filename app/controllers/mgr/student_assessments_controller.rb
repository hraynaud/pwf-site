class Mgr::StudentAssessmentsController < InheritedResources::Base
 before_filter :for_season, :only=>[:index, :new, :create]

  def index
    @student_assessments = StudentAssessment.joins(:aep_registration).where(["aep_registrations.season_id = ?",  @season.id])
  end
end
