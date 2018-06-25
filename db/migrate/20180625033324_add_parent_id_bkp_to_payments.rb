class AddParentIdBkpToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :parent_id_bkp, :integer
  end
end
