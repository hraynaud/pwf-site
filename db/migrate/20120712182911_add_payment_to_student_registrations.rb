class AddPaymentToStudentRegistrations < ActiveRecord::Migration
  def change
    add_column :student_registrations, :payment_id, :integer

  end
end
