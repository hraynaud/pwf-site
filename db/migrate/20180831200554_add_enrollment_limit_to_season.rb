class AddEnrollmentLimitToSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :seasons, :enrollment_limit, :integer
  end
end
