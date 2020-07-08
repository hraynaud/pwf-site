class AddInTrainingProgramToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :student_registrations, :in_training_program, :boolean
  end
end
