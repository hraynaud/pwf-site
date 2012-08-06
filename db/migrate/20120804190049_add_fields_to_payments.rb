class AddFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :method_cd, :integer

    add_column :payments, :check_no, :integer

  end
end
