class RenameMethodCdToPaymentMediumCd < ActiveRecord::Migration[5.2]
  def change
    rename_column :payments, :method_cd, :payment_medium_cd
  end
end
