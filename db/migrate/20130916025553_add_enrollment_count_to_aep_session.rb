class AddEnrollmentCountToAepSession < ActiveRecord::Migration
  def change
    add_column :aep_sessions, :enrollment_count, :integer
  end
end
