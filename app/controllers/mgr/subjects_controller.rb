class Mgr::SubjectsController < Mgr::BaseController
  skip_before_filter :require_mgr_user, :only => :create

  def create
   @subject = Subject.create params[:subject]
    respond_to do |format|
      format.html{
      redirect_to mgr_subjects_path
      }
      format.json{
        render :json => {term: @subject.name, id: @subject.id}
      }
    end
  end

end
