class TutorReportsController< InheritedResources::Base
  def create
    create! do |success, failure|
      success.html{
        flash.now[:notice]= "Report successfully saved" if resource.valid?
        apply_render_or_redirect
      }
    end
  end

  def update
    update! do|success, failure|
      success.html{
        apply_render_or_redirect
      }
    end
  end

  def edit
    edit!{
      redirect_to resource_path if resource.confirmed?
    }
  end

  def apply_render_or_redirect
    if !resource.confirmed?
      render :edit
    else
      redirect_to resource, :notice => "Report Confirmed and Finalized"
    end
  end

 protected
  def begin_of_association_chain
    @tutor ||=current_tutor
  end
end
