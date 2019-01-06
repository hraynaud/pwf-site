class AddParentIdBkpToDemographics < ActiveRecord::Migration[5.2]
  def change
    add_column :demographics, :parent_id_bkp, :integer
  end
end
