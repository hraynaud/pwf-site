class RenameUserTypeFields < ActiveRecord::Migration
 def change
   rename_column :users, :admin, :is_mgr
   rename_column :users, :parent, :is_parent
   rename_column :users, :tutor, :is_tutor
 end
end
