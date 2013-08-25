class AddDetailFieldsToAepRegistration < ActiveRecord::Migration
  def change
    add_column :aep_registrations, :learning_disability_details, :string
    add_column :aep_registrations, :iep_details, :string
  end
end
