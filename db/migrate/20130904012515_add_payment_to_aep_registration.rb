class AddPaymentToAepRegistration < ActiveRecord::Migration
  def change
    add_column :aep_registrations, :payment_status_cd, :integer, :default => 0
  end
end
