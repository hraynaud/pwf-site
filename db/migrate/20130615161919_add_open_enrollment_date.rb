class AddOpenEnrollmentDate < ActiveRecord::Migration
  def change
    add_column :seasons, :open_enrollment_date, :date

  end

end
