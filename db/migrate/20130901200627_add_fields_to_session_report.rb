class AddFieldsToSessionReport < ActiveRecord::Migration
  def change
    add_column :session_reports, :aep_registration_id, :integer
    add_column :session_reports, :student_registration_id, :integer
    add_column :session_reports, :session_date, :date
    add_column :session_reports, :worked_on_cd, :integer
    add_column :session_reports, :worked_on_other, :string
    add_column :session_reports, :preparation_cd, :integer
    add_column :session_reports, :participation_cd, :integer
    add_column :session_reports, :comprehension_cd, :integer
    add_column :session_reports, :motivation_cd, :integer
    add_column :session_reports, :comments, :string
  end
end
