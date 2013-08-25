class AddFieldsToAepRegistration < ActiveRecord::Migration
  def change
    add_column :aep_registrations, :learning_disablity, :boolean
    add_column :aep_registrations, :iep, :boolean
    add_column :aep_registrations, :student_academic_contract, :boolean
    add_column :aep_registrations, :parent_participation_agreement, :boolean
    add_column :aep_registrations, :transcript_test_score_release, :boolean
  end
end
