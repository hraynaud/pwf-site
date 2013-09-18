class MonthlyReportsController < TutorReportsController 


  def new 
    if params[:aep_registration_id].blank?
      flash[:error]="Please select a student"
      redirect_to collection_path
    else
      new!{
        @assignments = current_tutor.tutoring_assigmments
      }
    end
  end
 

end
