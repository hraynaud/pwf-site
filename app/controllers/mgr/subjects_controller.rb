class Mgr::SubjectsController < Mgr::BaseController

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
