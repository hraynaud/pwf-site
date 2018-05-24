class YearEndReportsController < TutorReportsController 


 def year_end_report_params 
   params.require(:year_end_report).permit(:academic_skills, :achievements, :attendance, 
    :challenges_concerns, :comments, :participation, :preparation, :recommendations)
end
