class AddAepRegistrationToTutoringAssignment < ActiveRecord::Migration
  def change
    add_column :tutoring_assignments, :aep_registration_id, :integer
  end
end
