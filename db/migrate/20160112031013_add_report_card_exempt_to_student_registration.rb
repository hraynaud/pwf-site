class AddReportCardExemptToStudentRegistration < ActiveRecord::Migration
  def change
    add_column :student_registrations, :report_card_exempt, :boolean
  end
end
