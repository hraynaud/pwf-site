class AddEthnicityToStudent < ActiveRecord::Migration
  def change
     add_column :students, :ethn_hispanic_latino, :boolean
     add_column :students, :ethn_black_african_american,:boolean
     add_column :students, :ethn_native_american, :boolean
     add_column :students, :ethn_asian, :boolean
     add_column :students, :ethn_pacific_islander, :boolean
     add_column :students, :ethn_caucasian, :boolean
     add_column :students, :ethn_other, :string
  end
end
