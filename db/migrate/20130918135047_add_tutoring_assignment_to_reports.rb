class AddTutoringAssignmentToReports < ActiveRecord::Migration
  def change
    add_column :session_reports, :tutoring_assignment_id, :integer
    add_column :monthly_reports, :tutoring_assignment_id, :integer
    add_column :year_end_reports, :tutoring_assignment_id, :integer
  end
end
