class SessionReportsController < InheritedResources::Base


  def create
    create! do |success, failure|
      success.html{
        flash.now[:notice]= "Session report successfully saved" if @session_report.valid?
        render :edit and return if !@session_report.confirmed?
          redirect_to @session_report, :notice => "Report Confirmed and Finalized"
      }
    end
  end

  def upate
    update! do|sucess, failure|
        success.html{
          render :edit and return if !@session_report.confirmed?
          redirect_to @session_report, :notice => "Report Confirmed and Finalized"
        }
    end
  end

end
