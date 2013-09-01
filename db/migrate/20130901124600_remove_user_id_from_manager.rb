class RemoveUserIdFromManager < ActiveRecord::Migration
  def change 
    remove_column :managers, :user_id
  end
end
