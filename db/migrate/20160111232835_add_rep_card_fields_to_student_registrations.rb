class AddRepCardFieldsToStudentRegistrations < ActiveRecord::Migration
  def change
    add_column :student_registrations, :first_report_card_received, :boolean
    add_column :student_registrations, :first_report_card_received_date, :date
    add_column :student_registrations, :second_report_card_received, :boolean
    add_column :student_registrations, :second_report_card_received_date, :date
    add_column :student_registrations, :method, :string
  end
end
