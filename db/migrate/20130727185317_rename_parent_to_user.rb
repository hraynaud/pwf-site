class RenameParentToUser < ActiveRecord::Migration
  def change
    rename_table :parents, :users
  end

end
