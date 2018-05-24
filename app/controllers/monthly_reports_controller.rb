class MonthlyReportsController < TutorReportsController 


  def index
    index!{
      @assignments = current_tutor.tutoring_assignments
    }
  end

 def monthly_report_params
  params.require(:monthly_report).permit(:goals_achieved, :issues_concerns, :issues_resolution, 
    :month, :new_goals_desc, :new_goals_set, :num_preparation_hours,
    :student_goals, :num_hours_with_student, :progress_notes )
 end

end
