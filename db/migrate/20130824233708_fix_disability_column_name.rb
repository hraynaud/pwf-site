class FixDisabilityColumnName < ActiveRecord::Migration
  def change
    rename_column :aep_registrations, :learning_disablity, :learning_disability
  end
end
