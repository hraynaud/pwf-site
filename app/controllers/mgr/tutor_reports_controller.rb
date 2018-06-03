
class Mgr::TutorReportsController< Mgr::BaseController
  before_action :load_assignments
  before_action :check_already_confirmed, :only=>[:edit,:update]

  def edit
    edit!{
      @assignments =[resource.tutoring_assignment]
    }
  end

  def update
    update! do|success, failure|
      success.html{
        handle_success
      }
    end
  end

  def handle_success
    msg = resource.confirmed? ? "confirmed and finalized" : "saved"
    redirect_to collection_path, :notice => "Report successfully #{msg}"
  end

  def check_already_confirmed
    redirect_to resource_path if resource.confirmed?
  end

  def load_assignments
    @assignments =TutoringAssignment.current.includes([:student, :tutor])
  end
end

