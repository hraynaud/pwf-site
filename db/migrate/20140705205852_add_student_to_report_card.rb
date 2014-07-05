class AddStudentToReportCard < ActiveRecord::Migration
  def change
    add_column :report_cards, :student_id, :integer
  end
end
