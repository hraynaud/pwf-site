class AddParentIdBkpToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :parent_id_bkp, :integer
  end
end
