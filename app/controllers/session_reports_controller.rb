class SessionReportsController < TutorReportsController

 
 def session_report_params

   params.require(:session_report).permit(:aep_registration_id, :worked_on_other, :session_date,:confirmed, 
    :worked_on, :preparation, :participation, :comprehension, :motivation, :comments)
 end 
end
