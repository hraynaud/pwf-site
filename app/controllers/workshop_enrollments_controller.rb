class WorkshopEnrollmentsController < InheritedResources::Base

  def new
    @workshop_enrollment = WorkshopEnrollment.new
    @aep_registration = AepRegistration.find(params[:aep_registration_id]) 
    @already_enrolled = @aep_registration.workshops.map(&:id)
    @workshops = Workshop.current.map{|w|[w.name, w.id]}
  end

  def create
    create!{
      aep_registration_path(@workshop_enrollment.aep_registration)
    }
  end
  def update
    @workshop_enrollment = WorkshopEnrollment.find(params[:id])
    @workshop_enrollment.status_cd = params[:status]
    @workshop_enrollment.save
    update!{}
  end

end
