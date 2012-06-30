class AddPwfParentIdTempParents < ActiveRecord::Migration
  def up
    add_column :temp_parents, :pwf_parent_id, :integer
  end

  def down
  end
end
