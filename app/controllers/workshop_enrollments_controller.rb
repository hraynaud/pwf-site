class WorkshopEnrollmentsController < InheritedResources::Base

  def new
    @workshop_enrollment = WorkshopEnrollment.new
    @aep_registration = AepRegistration.find(params[:aep_registration_id]) 
    @already_enrolled = @aep_registration.workshops.map(&:id)
    @workshops = Workshop.current.map{|w|[w.name, w.id]}
  end

end
