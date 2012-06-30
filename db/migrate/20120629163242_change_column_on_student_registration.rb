class ChangeColumnOnStudentRegistration < ActiveRecord::Migration
  def up
    change_column_default :student_registrations, :status_cd, 0
  end

  def down
  end
end
