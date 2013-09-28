class Mgr::WorkshopEnrollmentsController < Mgr::BaseController

  def new
    @workshops = Workshop.current.map{|w|[w.name, w.id]}
    @workshop_enrollment = WorkshopEnrollment.new
    @aep_registrations= AepRegistration.current.paid
  end

  def create
    create! do |success, failure|
      success.html{redirect_to mgr_workshop_enrollments_path}
      failure.html{
        @workshops = Workshop.current.map{|w|[w.name, w.id]}
        @aep_registrations= AepRegistration.current.paid
        @already_enrolled = @aep_registration.workshops.map(&:id)
        render :new
      }
    end
  end

  def update
    @workshop_enrollment = WorkshopEnrollment.find(params[:id])
    @workshop_enrollment.status_cd = params[:status]
    @workshop_enrollment.save
    update!{}
  end
end
