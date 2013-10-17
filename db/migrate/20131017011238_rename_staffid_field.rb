class RenameStaffidField < ActiveRecord::Migration
  def change
    rename_column :groups, :staff_id, :instructor_id
  end 
end
