class AddUserToParent < ActiveRecord::Migration
  def change
    add_column :parents, :user_id, :integer
  end
end
