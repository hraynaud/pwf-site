class SessionReportsController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html{
        flash.now[:notice]= "Session report successfully saved" if @session_report.valid?
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
    render :edit and return if !@session_report.confirmed?
    redirect_to @session_report, :notice => "Report Confirmed and Finalized"
  end

end
