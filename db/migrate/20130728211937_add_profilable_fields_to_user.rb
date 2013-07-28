class AddProfilableFieldsToUser < ActiveRecord::Migration
  def change
  add_column :users, :profileable_id, :integer
  add_column :users, :profileable_type, :string
  end
end
