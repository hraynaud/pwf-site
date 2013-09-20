class TutorReportsController< InheritedResources::Base
  before_filter :require_tutor_user
  before_filter :check_already_confirmed, :only=>[:edit,:update]
  def create
    create! do |success, failure|
      success.html{
        handle_success
      }
    end
  end

  def update
    update! do|success, failure|
      success.html{
        handle_success
      }
    end
  end

  def handle_success
    msg = resource.confirmed? ? "Confirmed and Finalized" : "Saved"
    redirect_to collection_path, :notice => "Report #{msg}"
  end


  protected
  def begin_of_association_chain
    @tutor ||=current_tutor
  end

  def check_already_confirmed
    redirect_to resource_path if resource.confirmed?
  end
end
