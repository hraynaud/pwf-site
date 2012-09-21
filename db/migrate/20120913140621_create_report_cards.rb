class CreateReportCards < ActiveRecord::Migration
  def change
    create_table :report_cards do |t|
      t.integer :student_registration_id

      t.timestamps
    end
  end
end
