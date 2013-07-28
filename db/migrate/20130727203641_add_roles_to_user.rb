class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :parent, :boolean
    add_column :users, :tutor, :boolean
  end
end
