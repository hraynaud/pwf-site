class FixEthnicity < ActiveRecord::Migration
  def change
    remove_column :students, :ethn_hispanic_latino
    remove_column :students, :ethn_black_african_american
    remove_column :students, :ethn_native_american
    remove_column :students, :ethn_asian
    remove_column :students, :ethn_pacific_islander
    remove_column :students, :ethn_caucasian
    remove_column :students, :ethn_other
    add_column :students, :ethinicity_id, :integer
  end
end
