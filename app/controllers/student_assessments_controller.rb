class StudentAssessmentsController < ApplicationController


  def student_assessment_params
    params.require(:student_assessment).permit(:aep_registration_id, :post_test_date, :post_test_grade, :pre_test_date, :pre_test_grade)
  end
end
