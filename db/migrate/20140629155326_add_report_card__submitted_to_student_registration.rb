class AddReportCardSubmittedToStudentRegistration < ActiveRecord::Migration
  def change
    add_column :student_registrations, :report_card_submitted, :boolean, default: false
  end
end
