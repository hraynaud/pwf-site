class FixEthnicityTypo < ActiveRecord::Migration
  def change
    rename_column :students, :ethinicity_id, :ethnicity_id
  end
end
