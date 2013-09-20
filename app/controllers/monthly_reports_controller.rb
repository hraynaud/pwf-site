class MonthlyReportsController < TutorReportsController 


  def index
    index!{
      @assignments = current_tutor.tutoring_assignments
    }
  end

  def new 
    if params[:tutoring_assignment_id].blank?
      flash[:error]="Please select a student"
      redirect_to collection_path
    else

        @assignment = current_tutor.tutoring_assignments.find(params[:tutoring_assignment_id])
        if(@assignment)
           @monthly_report = current_tutor.monthly_reports.build(:tutoring_assignment_id => @assignment.id)
           @student_name = @assignment.student_name
        else
          flash[:error]="You do not have permission to create a report for this student"
          redirect_to collection_path
        end
    end
  end
end
