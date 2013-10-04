class MonthlyReportsController < TutorReportsController 


  def index
    index!{
      @assignments = current_tutor.tutoring_assignments
    }
  end

end
