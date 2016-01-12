class AddReportCardExpectedDatesToStudentRegistrations < ActiveRecord::Migration
  def change
    add_column :student_registrations, :first_report_card_expected_date, :date
    add_column :student_registrations, :second_report_card_expected_date, :date
  end
end
