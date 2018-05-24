class TutoringAssignmentsController < InheritedResources::Base
  def tutoring_assignment_params
    
    params.require(tutoring_assignment).permit(:notes, :aep_registration_id, :subject_id, :tutor_id)
  end
end
