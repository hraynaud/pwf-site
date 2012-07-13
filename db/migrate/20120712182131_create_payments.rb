class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal  "amount",         :precision => 8, :scale => 2, :default => 1.0
      t.string   "payment_method"
      t.string   "token"
      t.string   "identifier"
      t.string   "payer_id"
      t.boolean  "recurring",                                    :default => false
      t.boolean  "digital",                                      :default => false
      t.boolean  "popup",                                        :default => false
      t.boolean  "completed",                                    :default => false
      t.boolean  "canceled",                                     :default => false
      t.integer  "parent_id"
      t.timestamps
    end
  end
end
